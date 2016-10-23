-- spreadsheet-drop.sql
--
-- @author Benjamin Brink
-- @copyright 2014
-- @for OpenACS.org
-- @cvs-id

drop index qss_tips_field_values_trashed_p_idx;
drop index qss_tips_field_values_field_f_vc1k_idx;
drop index qss_tips_field_values_row_nbr_idx;
drop index qss_tips_field_values_table_id_idx;
drop index qss_tips_field_values_instance_id_idx;
DROP TABLE qss_tips_field_values;

drop index qss_tips_field_defs_trashed_p;
drop index qss_tips_field_defs_table_id;
drop index qss_tips_field_defs_id_idx;
drop index qss_tips_field_defs_instance_id_idx;
DROP TABLE qss_tips_field_defs;
drop index qss_tips_table_defs_trashed_p_idx;
drop index qss_tips_table_defs_label_idx;
drop index qss_tips_table_defs_id_idx;
drop index qss_tips_table_defs_instance_id_idx;
DROP TABLE qss_tips_table_defs;
drop index qss_tips_data_types_type_name_idx;
drop index qss_tips_data_types_instance_id_idx;
DROP TABLE qss_tips_data_types;       

drop SEQUENCE qss_tips_id_seq;

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

