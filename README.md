SPREADSHEET
===========

For the latest updates to this readme file, see: http://openacs.org/xowiki/spreadsheet

The latest version of the code is available at the development site:
 http://github.com/tekbasse/spreadsheet

introduction
------------

Spreadsheet provides procedures for building and using tables and 
spreadsheets in OpenACS. It is an OpenACS package that allows convenient 
building and interpreting of web-based sheets via tcl in a web page.

Standard spreadsheets are not yet supported.

license
-------
Copyright (c) 2013 Benjamin Brink
po box 20, Marylhurst, OR 97036-0020 usa
email: tekbasse@yahoo.com

Spreadsheet is open source and published under the GNU General Public License, consistent with the OpenACS system: http://www.gnu.org/licenses/gpl.html
A local copy is available at spreadsheet/LICENSE.html

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

features
--------

Integrates well with Q-Forms or any web-based form processing.

Can manipulate Tcl list of lists for easy generation of reports.

There are procedures for importing, rotating, and exporting tables
in various formats, including changing Tcl lists to arrays 
and lists to scalar variables.

Simple Table API is for tables represented as text, where each line is a row, and 
each cell is separated by a common or specified delimiter.

TIPS "Table Integrated Publishing System" API is a database
paradigm used extensively for developing data models in flux 
and importing or converting databases from one format to another.
It was first developed in the 1990's.


Simple Table API
----------------

One key feature is Simple Table's ability to guess at most likely common field
and end-of-line delimiters based on a statistical analysis of text.


TIPS API
--------

TIPS API is based on the flexibility of spreadsheets, where:

*   There is no difference between a cell with null or empty string value.

*   There are only 3 "formula" types, numeric, text and vc1k (varchar(1025)).

*   Any type can have an empty value.

*   A vc1k declared column can be referenced by first or most recent, 
    or all cases of search-string. Foreign Keys are not constrained.

*   A missing key returns an empty row/cell. In essence code level errors are avoided.

*   Data updates can be by row or cell or column.

*   Unreferenced columns are ignored. 

*   All columns are assumed if none referenced.

*   Rows and columns are referenced by internal row_id and field_id (column) or field/column "label".

*   Tables can be imported via Simple Table's TCL representation of a table in list of lists format,
    where the first row contains column labels.

Revisioning is trackable per cell and timestamp, for implementing an "undo" or revisioning capability.

