-- spreadsheet-simple-drop.sql
--
-- @author Dekka Corp.
-- @for OpenACS.org
-- @cvs-id
--
DROP index qss_simple_cells_idx;
DROP TABLE qss_simple_cells;

DROP index qss_simple_table_id_idx;
DROP index qss_simple_table_template_id_idx;
DROP index qss_simple_table_instance_id_idx;    
DROP index qss_simple_table_user_id_idx;        
DROP TABLE qss_simple_table;

DROP TABLE qss_simple_object_id_map;
DROP SEQUENCE qss_simple_id_seq;
