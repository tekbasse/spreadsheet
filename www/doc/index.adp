<master>
<property name="title">@title;noquote@</property>
<property name="context">@context;noquote@</property>

<h2>Spreadsheet Package @title@</h2>

<p>The lastest release version of the code is available at:
 http://github.com/dcpm/spreadsheet
</p>
<h3>
introduction
</h3>
<p>
Spreadsheet provides procedures for building and using tables and 
spreadsheets in OpenACS. This package allows convenient 
building and interpreting of web-based table data via tcl in a web page.
</p><p>
This package provides two different API implementations:
</p>
<ul><li>
Simple Table - stores and retrieves static tables as delimited text.
Most any delimiter is automatically handled on input. Delimiters can
be forced if necessary. Sheets have built-in revisioning and permissions.
</li><li>
Standard spreadsheets - stores and retrieves sheets with formula 
and calculation values stored for each cell. (Not yet implemented)
</li></ul>
</pre>
<h3>license</h3>
<pre>
Copyright (c) 2014 Benjamin Brink
po box 20, Marylhurst, OR 97036-0020 usa
email: tekbasse@yahoo.com

Spreadsheet Package is open source and published under the GNU General Public License, 
consistent with the OpenACS system license: http://www.gnu.org/licenses/gpl.html
A local copy is available at spreadsheet/www/doc/<a href="LICENSE.html">LICENSE.html</a>

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
</pre>

<h3>Package features</h3>
<ul><li>
Integrates well with Q-Forms or any web-based form processing.
</li><li>
Tables can be represented as text, where each line is a row, and 
each cell is separated by a common or specified delimiter.
</li><li>
Can manipulate Tcl list of lists for easy generation of reports.
</li><li>
There are procedures for importing, rotating, and exporting tables
 in various formats for easy use in tcl.
</li></ul>
