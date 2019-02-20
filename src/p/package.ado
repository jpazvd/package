*! version 1.0.2 		<18Feb2019>		JPAzevedo
*		add README.md option
*! version 1.0.1 		<17Feb2019>		JPAzevedo
*! version 1.0.0 		<16Feb2019>		JPAzevedo
*	Original

program define package, rclass

	version 14

	syntax , 					///
		name(string) 			///
		[ 						///
			path(string) 			///
			prefix(string) 			///
			version(string) 		///
			title(string)		///
			description(string)	///
			date(string) 		///
			author(string) 		///
			institution(string) ///
			email(string) 		///
			web(string) 		///
			license(string) 	///
			note(string)		///
			keyword(string)		///
			handle(string)		///
			readme(string)		///
			replacepkg 			///
			appendpkg			///
			replacetoc 			///
			appendtoc			///
			replacereadme		///
			appendreadme		///
			toc					///
			pkg					///
			quietly				///
		]

	return add
	
	if ("`title'" != "") {
		local title ": `title'"
	}
	if ("`quietly'" != "") {
		local noi noisily
	}
	if ("`replacepkg'" != "") {
		local replacepkg "replace"
	}
	if ("`appendpkg'" != "") {
		local appendpkg "append"
	}
	if ("`replacetoc'" != "") {
		local replacetoc "replace"
	}
	if ("`appendtoc'" != "") {
		local appendtoc  "append"
	}
	if ("`replacereadme'" != "") {
		local replacereadme "replace"
	}
	if ("`appendreadme'" != "") {
		local appendreadme "append"
	}

************************************************************

	local filename "`name'.pkg"
	local filename "`path'/`name'/`filename'"
	
************************************************************
	
	
	`noi' di ""
	`noi' di ""
	`noi' cd "`path'"
	`noi' cd "`name'/`prefix'/"

************************************************************

	if ("`date'" == "") {
		local datef = c(current_date)
	}
	if ("`license'" == "") {
		local license "MIT"
	}
	
	local upper = strupper("`name'")

	************************************************************

	tempfile in out2
	tempname in2 		
	`noi' di ""
	
if ("`pkg'" == "pkg") {
	
	tempname outpkg
			
	file open `outpkg'    using 	"`filename'"   		, write text `appendpkg' `replacepkg'

		file write `outpkg'	"v `version'"	_n
		file write `outpkg' 	"d '`upper''`title'"	_n
		file write `outpkg' 	"d "	_n
		file write `outpkg' 	"d Distribution-Date: `date'"	_n
		file write `outpkg' 	"d License: `license'"	_n
		file write `outpkg' 	"d "	_n

		local list1 : dir  . dirs "*" 
		local n1 = wordcount(`"`list1'"')
		local tmp1 = subinstr(`"`list1'"',`"""',"",.)

		forvalues a = 1(1)`n1' {
			
			local v`a' = word("`tmp1'", `a') 
			qui di "`a'  - `v`a''"
			qui cd `v`a''/
			qui cd
			
			local list2 : dir  . dirs "*" 
			local n2 = wordcount(`"`list2'"')
			
			if (`n2' == 0) {
				local list2 : dir  . files "*" 
				local flag = 1
			}
			
			local n2 = wordcount(`"`list2'"')
			local tmp2 = subinstr(`"`list2'"',`"""',"",.)
			
			forvalues b = 1(1)`n2' {

				if (`flag' != 1) {
				
					local k`b' = word("`tmp2'", `b') 
					qui cd `k`b''/
					
					local list3 : dir  . files "*" 
					local n3 = wordcount(`"`list3'"')
					local tmp3 = subinstr(`"`list3'"',`"""',"",.)

					forvalues c = 1(1)`n3' {
					
						local j`c' = word("`tmp3'", `c') 
						`noi' di "`prefix'/`v`a''/`k`b''/`j`c''"
						file write `outpkg'	"F `prefix'/`v`a''/`k`b''/`j`c''"	_n
					
					}
					
					qui cd ..
				
				}
				
				if (`flag' == 1)  {
				
					local k`b' = word("`tmp2'", `b') 
					`noi' di "`prefix'/`v`a''/`k`b''"
					file write `outpkg'	"F `prefix'/`v`a''/`k`b''"	_n
				}
			}
			
			qui cd ..
		}

	file close `outpkg'
	
}


	*********************************************************

qui if ("`toc'" == "toc") {

	tempname outtoc

	file open `outtoc'    using 	"`path'/`name'/stata.toc"   		, write text `appendtoc' `replacetoc'

		file write `outtoc'	"v `version'"	_n
		file write `outtoc'	"d Materials by `author'"	_n
		file write `outtoc'	"d `institution'"	_n
		file write `outtoc'	"d `email'"	_n
		file write `outtoc'	"d `web'"	_n
		file write `outtoc'	" "	_n
		file write `outtoc'	"p `name'"	_n
			
	file close `outtoc'

}

	*********************************************************

if ("`readme'" != "") {
	
	tempname outreadme
			
	file open `outreadme'    using 	"`path'/`name'/`readme'.md"    , write text `appendreadme' `replacereadme' 
	
		if ("`title'" != "") {
			file write `outreadme' 	"# '`upper''`title'"	_n
			file write `outreadme' 	""	_n
		}

		if ("`description'" != "") {
			file write `outreadme' 	""	_n
			file write `outreadme' 	"## Description: "	_n
			file write `outreadme' 	"  `description'  "	_n
			file write `outreadme' 	""	_n
		}

		if ("`handle'" != "") {
			file write `outreadme' 	""	_n
			file write `outreadme' "#### Handle: `handle'  " _n 
			file write `outreadme' 	""	_n
		}

		if ("`note'" != "") {
			file write `outreadme' 	""	_n
			file write `outreadme' 	"#### Notes: "	_n
			file write `outreadme' 	"  `note'  "	_n
			file write `outreadme' 	""	_n
		}

		if ("`keywords'" != "") {
			file write `outreadme' 	""	_n
			file write `outreadme' 	"#### Keywords: "	_n
			file write `outreadme' 	"  `keywords'  "	_n
			file write `outreadme' 	""	_n
		}
		
		if ("`author'" != "") {
		
			file write `outreadme' 	""	_n
			
			foreach key in author email institution web {
				local k = substr("`key'",1,1)
				local `key'2 = subinstr("``key''" , " and ", " , ",.)
				tknz "``key'2'" , s(`k') p(",")
				local `k'n = s(items)
				local max "`max', ``k'n'"
			}

			local max = max(`max')+1
						
			if (`max'== 2) {
			
				local v = 1
			
				local `a`v''= trim("`a`v''")
				
				file write `outreadme' 	"## Author: "	_n
				file write `outreadme' 	""	_n
				file write `outreadme' 	"  **`a`v''**  "	_n
				if (trim("`e`v''") != "") & strmatch(trim("`e`v''"),"no*") != 1 {
					file write `outreadme' 	"  [`e`v''](mailto:`e`v'')  "	_n
				}
				if (trim("`i`v''") != "") & strmatch(trim("`i`v''"),"no*") != 1  {
					file write `outreadme' 	"  `i`v''  "	_n
				}
				if (trim("`w`v''") != "") & strmatch(trim("`w`v''"),"no*") != 1 {
					file write `outreadme' 	"  [personal page](`w`v'')  "	_n
				}
				file write `outreadme' 	""	_n
			}
			
			else {

				file write `outreadme' 	"## Authors: "	_n
				file write `outreadme' 	""	_n
				
				forvalues v = 1(2)`max' {

					local `a`v''= trim("`a`v''")

					file write `outreadme' 	"  **`a`v''**  "	_n
					
					if (trim("`e`v''") != "") & strmatch(trim("`e`v''"),"no*") != 1 {
						file write `outreadme' 	"  [`e`v''](mailto:`e`v'')  "	_n
					}
					if (trim("`i`v''") != "") & strmatch(trim("`i`v''"),"no*") != 1  {
						file write `outreadme' 	"  `i`v''  "	_n
					}
					if (trim("`w`v''") != "") & strmatch(trim("`w`v''"),"no*") != 1 {
						file write `outreadme' 	"  [personal page](`w`v'')  "	_n
					}
					file write `outreadme' 	""	_n
				}
			
			}	
		}
				
	file close `outreadme'
	
}
	
************************************************************

	return local name 			"`name'"
	return local prefix 		"`prefix'"
	return local path 			"`path'"
	return local version 		"`version'"
	return local author 		"`author'"
	return local institution 	"`institution'"
	return local email 			"`email'"
	return local web 			"`web'"
	return local license 		"`license'"
	return local title			"`title'"
	return local description 	"`description'"
	return local note			"`note'"
	return local keyword		"`keyword'"
	
	
end
