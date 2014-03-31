body {
	margin:0px;
	background-color:#DBDBDB;
}

#menuContainer {
	PADDING-RIGHT: 0px; PADDING-LEFT: 0px; PADDING-BOTTOM: 0px; WIDTH: 100%; PADDING-TOP: 0px; float:left; height:100%;
}
#menu {
	width: 100%;
	background-image:url(../../../../../../Umesh/Ffreedom%20Website%20ScreensV2/New%20Folder/Website/03_Development/SlicedImages/images/index_08.jpg);
	height: 33px;
	color: #000000;
	font-family: Verdana;
}

#menu  ul {
	display: block;
	margin: 0;
	padding: 0;
	line-height: 1em;
	list-style: none;
	z-index: 90
}

#menu  ul li {
	float: left;
	margin: 0 3px 0 0;
	padding: 0;
	font-size: 12px;
	line-height: 1, 5em;
	list-style-type: none;
}

#menu ul li a {
	float: left;
	display: block;
	width: auto;
	font-weight: normal;
	background: transparent;
	text-decoration: none;
	
	margin: 0;
	padding: 0.9em 0.8em 0.5em 1em;
}

#menu  ul li a:hover {
	
	text-decoration: none;
}

#menu  ul li.sep {
	
	padding: 0.8em 0em 0.5em 0em;
}

/* Commented Backslash Hack hides rule from IE5-Mac \*/
#menu  ul li a {
	float: none;
}

/* End IE5-Mac hack */
#menu  ul.level2, #menu ul.level3 {
	position: absolute;
	top: 0px;
	left: 0px;
	visibility: hidden;
	border-left: 1px solid #fff;
	border-top: 1px solid #fff;
	border-right: 1px solid #fff;
	background:#D7D7D7;
}

#menu  ul.level2 li, #menu ul.level3 li {
	float: none;
	margin: 0;
	padding: 0;
	
}

#menu  ul.level2 li a, #menu ul.level3 li a {
	padding: 5px 9px 5px 5px;
}

#menu  ul.level2 li a:hover,#menu  ul.level3 li a:hover {
	font-weight: normal;
	background-color:#F60;
	background-image: none;
}
