module Database

using LibPQ  # PostgreSQL driver for Julia (assuming we're using RDS PostgreSQL)
using Printf

# Function to connect to the RDS PostgreSQL database
function connect_to_rds(host::String, dbname::String, user::String, password::String, port::Int=5432)
    connection_string = @sprintf "host=%s dbname=%s user=%s password=%s port=%d" host dbname user password port
    return LibPQ.Connection(connection_string)
end

# Function to initialize the database table if it doesn't exist
function init_db(conn::LibPQ.Connection)
    query = """
    CREATE TABLE IF NOT EXISTS nodes (
        id SERIAL PRIMARY KEY,
        hostname TEXT NOT NULL,
        version TEXT NOT NULL
    );
    """
    LibPQ.execute(conn, query)
end

# Function to get the current node count from the database
function get_node_count(conn::LibPQ.Connection)
    query = "SELECT COUNT(*) FROM nodes"
    result = LibPQ.execute(conn, query)
    row = LibPQ.Tuple(result)
    return parse(Int, row[1]) + 1  # Increment for the next node
end

# Function to add a new node record to the database
function add_node_record(conn::LibPQ.Connection, hostname::String, version::String)
    query = "INSERT INTO nodes (hostname, version) VALUES ($1, $2)"
    LibPQ.execute(conn, query, (hostname, version))
end

# Close the database connection
function close_db(conn::LibPQ.Connection)
    LibPQ.finish(conn)
end

end  # module Database
