-- spreadsheet--simple-create.sql
--
-- @author Dekka Corp.
-- @for OpenACS.org
-- @cvs-id
--

-- we are not going to reference acs_objects directly, so that this can be used
-- separate from acs-core.
CREATE TABLE qss_simple_object_id_map (
     sheet_id integer,
     object_id integer 
        -- sheet_id can be constrained to object_id for permissions
);


CREATE SEQUENCE qss_simple_id_seq start 10000;
SELECT nextval ('qss_simple_id_seq');


CREATE TABLE qss_simple_table (
        id integer not null primary key,
        template_id integer,
        instance_id integer,
        -- object_id of mounted instance (context_id)
        user_id integer,
        -- user_id of user that created spreadsheet
        name varchar(40),
        title varchar(80),
        cell_count integer,
        row_count integer,
        trashed varchar(1),
        popularity integer,
        flags varchar(12),
        last_modified timestamptz,
        created timestamptz,
        comments text
     );    

create index qss_simple_table_id_idx on qss_simple_table (id);
create index qss_simple_table_template_id_idx on qss_simple_table (template_id);
create index qss_simple_table_instance_id_idx on qss_simple_table (instance_id);
create index qss_simple_table_user_id_idx on qss_simple_table (user_id);
create index qss_simple_table_trashed_idx on qss_simple_table (trashed);

    CREATE TABLE qss_simple_cells (
        table_id integer not null,
        --  should be a value from qss_simple_table.id
        -- no need to track revisions. Each table is a new revision.
        cell_rc varchar(20) not null, 
        cell_value varchar(1025)
        -- user input value
        );

create index qss_simple_cells_idx on qss_simple_cells (table_id);
