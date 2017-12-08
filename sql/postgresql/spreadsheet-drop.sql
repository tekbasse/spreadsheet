-- spreadsheet-drop.sql
--
-- @author Benjamin Brink
-- @copyright 2014
-- @for OpenACS.org
-- @cvs-id


drop index qss_cells_sheet_id_idx;
drop index qss_cells_id_idx;
DROP TABLE qss_cells;
drop index qss_sheets_trashed_idx;
drop index qss_sheets_user_id_idx;
drop index qss_sheets_instance_id_idx;
drop index qss_sheets_template_id_idx;
drop index qss_sheets_id_idx;

DROP TABLE qss_sheets;
DROP SEQUENCE qss_id_seq;
DROP TABLE qss_sheets_object_id_map;
drop index qss_simple_cells_table_id_idx;
DROP TABLE qss_simple_cells;
drop index qss_simple_table_trashed_idx;
drop index qss_simple_table_user_id_idx;
drop index qss_simple_table_instance_id_idx;
drop index qss_simple_table_template_id_idx;
drop index qss_simple_table_id_idx;

DROP TABLE qss_simple_table;
DROP SEQUENCE qss_simple_id_seq;
DROP TABLE qss_simple_object_id_map;

