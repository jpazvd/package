*! version 1.0.3 		<20Feb2019>		JPAzevedo & RCastaneda
*		add create help option, minor changes, package.shlp added
* version 1.0.2 		<18Feb2019>		JPAzevedo
*		add README.md option
* version 1.0.1 		<17Feb2019>		JPAzevedo
* version 1.0.0 		<16Feb2019>		JPAzevedo
*	Original

program define package, rclass

	version 14

	syntax [anything(name=name2)], 					///
		[ 						///
			name(string) 			///
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
			github(string) 		///
			linkdn(string) 		///
			twitter(string) 	///
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
			toc					  ///
			pkg					  ///
			helpfile  	  ///
			replacehelp  	///
			QUIetly				///
		]

	return add  // ??? I don't think this should go here. 
	
/*==================================================
           Conditions
==================================================*/

	if ( ("`name'" == "" & "`name2'" == "") |  /* 
	 */  ("`name'" != "" & "`name2'" != "") ) {
		noi disp in r "you must use one of the two syntaxes below:" _n /* 
		 */  in y "Syntax 1: " in w "package {it:pkgname}" _n /*
		 */  in y "Syntax 2: " in w "package, name({it:pkgname})"  
		error
	}
	if ("`name2'" != "") local name "`name2'"
	
	if ("`title'" != "") {
		local title ": `title'"
	}
	if ("`quietly'" == "") {
		local noi noisily
	}
	else local noi qui

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
	if ("`replacehelp'" != "") {
		local replacehelp "replace"
	}
	if ("`appendreadme'" != "") {
		local appendreadme "append"
	}
	if ("`version'" == "") {
		local version = 3 // see help usersite##remarks8
	}
	if ("`path'" == "") {
		local path "`c(pwd)'"
		noi disp in r "Note: " in y "you did not specify a directory path. " _c /* 
		 */ "{cmd:package} will use current directory: " _n /* 
		 */ in w "`path'"
	}
	if ("`author'" == "") {
		local author = "`c(username)'"
		noi disp in y "option {it:author()} has been set to `author'"
	}

************************************************************
	cap mkdir "`path'/`name'"
	if (_rc == 0) {
		noi disp in y "`path'/`name' has been created."
	}
	local filename "`name'.pkg"
	local filename "`path'/`name'/`filename'"
	
************************************************************
	
	
	`noi' di ""
	`noi' di ""
	 local usercd "`c(pwd)'"
	* `noi' cd "`path'"
	* `noi' cd "`name'/`prefix'/"

************************************************************

	if ("`date'" == "") {
		local date: disp %td date("`c(current_date)'", "DMY")
	}
	if ("`license'" == "") {
		local license "MIT"
	}
	
	local upper = strupper("`name'")

	************************************************************

	tempfile in out2
	tempname in2 		
	`noi' di ""
	
qui if ("`pkg'" == "pkg") {
	
	tempname outpkg
			
	file open `outpkg'    using 	"`filename'"   		, write text `appendpkg' `replacepkg'

		file write `outpkg'	"v `version'"	_n
		file write `outpkg' 	"d '`upper''`title'"	_n
		file write `outpkg' 	"d "	_n
		file write `outpkg' 	"d Distribution-Date: `date'"	_n
		file write `outpkg' 	"d License: `license'"	_n
		file write `outpkg' 	"d "	_n

		*---------- Files in the root of the directory
		
		local toexclude "md$|pkg$|toc$|gitattributes|LICENSE|gitignore"
		local files: dir "`path'/`name'" files "*"
		foreach file of local files {
			if regexm("`file'", "`toexclude'") continue
			file write `outpkg'	"F `file'"	_n
		}
		
		*---------- Files in subdirectories
		local dirs: dir "`path'/`name'" dirs "*"
		
		gettoken dir dirs : dirs
		while ("`dir'" != "")  {
			if regexm("`dir'", "^\.git|^_") {
				gettoken dir dirs : dirs
				continue
			}
			
			local files: dir "`path'/`name'/`dir'" files "*"
			
			if (`"`files'"' != "") {
				foreach file of local files {
					if regexm("`file'", "`toexclude'") continue
					file write `outpkg'	"F `dir'/`file'"	_n
				}	
			}
			
			local subdirs: dir "`path'/`name'/`dir'" dir "*"
			
			if (`"`subdirs'"' != "") {
				foreach subdir of local subdirs {
					if regexm("`subdir'", "^\.git|^_") continue
					local dirs "`dirs' `dir'/`subdir'"
				}		
			}
			gettoken dir dirs : dirs
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

qui if ("`readme'" != "") {
	
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

/*==================================================
           Help file
==================================================*/

qui if ("`helpfile'" != "") {
	tempfile fout
	tempname f
	local date: disp %tdDD_Mon_CCYY date("`c(current_date)'", "DMY")
	local datetime: disp %tcDDmonthCCYY-HHMMSS clock("`c(current_date)'`c(current_time)'", "DMYhms")
	local datetime = trim("`datetime'")
	
	file open `f' using "`path'/`name'/`name'.sthlp", write `replacehelp'
	
	file write `f' `"{smcl}"' _n 
	file write `f' `"{* *! version 1.0 `date'}{...}"' _n 
	file write `f' `"{vieweralsosee "" "--"}{...}"' _n 
	file write `f' `"{vieweralsosee "Install CCC" "ssc install CCC"}{...}"' _n 
	file write `f' `"{vieweralsosee "Help CCC (if installed)" "help CCC"}{...}"' _n 
	file write `f' `"{viewerjumpto "Syntax" "`name'##syntax"}{...}"' _n 
	file write `f' `"{viewerjumpto "Description" "`name'##description"}{...}"' _n 
	file write `f' `"{viewerjumpto "Options" "`name'##options"}{...}"' _n 
	file write `f' `"{viewerjumpto "Remarks" "`name'##remarks"}{...}"' _n 
	file write `f' `"{viewerjumpto "Examples" "`name'##examples"}{...}"' _n 
	file write `f' `"{title:Title}"' _n 
	file write `f' `"{phang}"' _n 
	file write `f' "{bf:`name'} {hline 2} `title'" _n 
	file write `f' `""' _n 
	file write `f' `"{marker syntax}{...}"' _n 
	file write `f' `"{title:Syntax}"' _n 
	file write `f' `"{p 8 17 2}"' _n 
	file write `f' `"{cmdab:`name'}"' _n 
	file write `f' `"anything"' _n 
	file write `f' `"[{cmd:,}"' _n 
	file write `f' "{it:options}]" _n 
	file write `f' `""' _n 
	file write `f' `"{synoptset 20 tabbed}{...}"' _n 
	file write `f' `"{synopthdr}"' _n 
	file write `f' `"{synoptline}"' _n 
	file write `f' `"{syntab:Main}"' _n 
	file write `f' `"{synopt:{opt option1(string)}} .{p_end}"' _n 
	file write `f' `"{synopt:{opt option2(numlist)}} .{p_end}"' _n 
	file write `f' `"{synopt:{opt option3(varname)}} .{p_end}"' _n 
	file write `f' `"{synopt:{opt te:st}} .{p_end}"' _n 
	file write `f' `"{synoptline}"' _n 
	file write `f' `"{p2colreset}{...}"' _n 
	file write `f' `"{p 4 6 2}"' _n 
	file write `f' `""' _n 
	file write `f' `"{marker description}{...}"' _n 
	file write `f' `"{title:Description}"' _n 
	file write `f' `"{pstd}"' _n 
	file write `f' "{cmd:`name'} `description'" _n 
	file write `f' `""' _n 
	file write `f' `"{marker options}{...}"' _n 
	file write `f' `"{title:Options}"' _n 
	file write `f' `"{dlgtab:Main}"' _n 
	file write `f' `"{phang}"' _n 
	file write `f' `"{opt option1(string)}"' _n 
	file write `f' `""' _n 
	file write `f' `"{phang}"' _n 
	file write `f' `"{opt option2(numlist)}"' _n 
	file write `f' `""' _n 
	file write `f' `"{phang}"' _n 
	file write `f' `"{opt option3(varname)}"' _n 
	file write `f' `""' _n 
	file write `f' `"{phang}"' _n 
	file write `f' `"{opt te:st}"' _n 
	file write `f' `""' _n 
	file write `f' `""' _n 
	file write `f' `"{marker examples}{...}"' _n 
	file write `f' `"{title:Examples}"' _n 
	file write `f' `""' _n 
	file write `f' "{phang} <insert example command>" _n 
	file write `f' `""' _n 
	file write `f' `"{title:Author}"' _n 
	file write `f' `"{p}"' _n 
	file write `f' `""' _n 
	file write `f' `"<insert name>, <insert institution>."' _n 
	file write `f' `""' _n 
	file write `f' `"Email {browse "mailto:firstname.givenname@domain":firstname.givenname@domain}"' _n 
	file write `f' `""' _n 
	file write `f' `"{title:See Also}"' _n 
	file write `f' `""' _n 
	file write `f' `"NOTE: this part of the help file is old style! delete if you don't like"' _n 
	file write `f' `""' _n 
	file write `f' `"Related commands:"' _n 
	file write `f' `""' _n 
	file write `f' "{help command1} (if installed)" _n 
	file write `f' "{help command2} (if installed)   {stata ssc install command2} (to install this command)" _n 
	file write `f' `""' _n 

	file close `f'

}


cd "`usercd'"
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
