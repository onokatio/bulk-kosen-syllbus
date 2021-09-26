set -eu

SCHOOL=14
DEPARTMENT=14

function getSubjectIds(){
	YEAR="$1"
	GRADE="$2"
	COL1="$(( 6+(4*(GRADE-1)) ))"
	COL2="$(( COL1 + 2 ))"
	curl -Ss "https://syllabus.kosen-k.go.jp/Pages/PublicSubjects?school_id=${SCHOOL}&department_id=${DEPARTMENT}&year=${YEAR}&lang=ja" | pup 'table#sytablenc tbody tr json{}' | jq -r ".[4:][] | {\"sub\": .children[2], \"a\": .children[${COL1}], \"b\": .children[${COL2}]} | select(.a.text or .b.text) | .sub.children[0].children[0].href" | sed -e 's/\&amp;/\&/g' | sed -r 's/.+subject_id=(.+)\&year=(.+)\&.+/\1 \2/'
}

function getPDFUrls(){
	getSubjectIds "$1" "$2" | while read line
		do
			id=`echo $line | cut -d ' ' -f 1`
			year=`echo $line | cut -d ' ' -f 2`
			echo "https://syllabus.kosen-k.go.jp/Pages/SyllabusPDF?school_id=${SCHOOL}&department_id=${DEPARTMENT}&subject_id=${id}&year=${year}&lang=ja&subject_code=&preview=False&type=start&attachment=true"
		done
}

function getPDF(){
	mkdir -p "./pdfs/$1-$2"
	getPDFUrls "$1" "$2" | while read line;do wget --show-progress -nv -P "./pdfs/$1-$2/" --content-disposition "$line";done
	pdfunite ./pdfs/$1-$2/*.pdf ./pdfs/$1-$2.pdf
}

function joinAllPDF(){
	pdfunite ./pdfs/*.pdf ./all.pdf
}

rm -rf ./pdfs

getPDF 2016 1
getPDF 2017 2
getPDF 2019 3
getPDF 2020 4
getPDF 2021 5
joinAllPDF
