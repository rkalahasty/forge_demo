using HTTP
using Sockets
using SQLite  # Or use PostgreSQL.jl for RDS PostgreSQL interaction
using Printf

# Database configuration (using SQLite locally for now, but will modify to RDS later)
const db_path = "app_db.sqlite"  # Placeholder path, to be changed for RDS

# Helper function to connect to the RDS database
function connect_to_db()
    return SQLite.DB(db_path)  # This will be replaced with actual RDS connection
end

# Initialize the database table if not exists
function init_db(db)
    query = """
    CREATE TABLE IF NOT EXISTS nodes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        hostname TEXT,
        version TEXT
    )
    """
    SQLite.execute(db, query)
end

# Fetch the current node count
function get_node_count(db)
    query = "SELECT COUNT(*) FROM nodes"
    result = SQLite.query(db, query)
    return result[1][1] + 1  # Increment by 1 for the next instance
end

# Insert a new node record
function add_node_record(db, hostname, version)
    query = "INSERT INTO nodes (hostname, version) VALUES (?, ?)"
    SQLite.execute(db, query, hostname, version)
end

# Main function to serve the web page
function run_server()
    db = connect_to_db()
    init_db(db)

    node_number = get_node_count(db)
    hostname = "Node-$(node_number)"
    version = "1.0"  # Hardcoded for now, can be changed for version management

    add_node_record(db, hostname, version)

    # Define a simple HTTP handler
    function handler(req::HTTP.Request)
        response_body = """
        <html>
            <head><title>Node Info</title></head>
            <body>
                <h1>Hostname: $hostname</h1>
                <h2>Version: $version</h2>
            </body>
        </html>
        """
        return HTTP.Response(200, response_body)
    end

    # Start the server
    println("Starting server at http://localhost:8080")
    HTTP.serve(handler, ip"0.0.0.0", 8080)  # Listen on all interfaces
end

# Start the app
run_server()
