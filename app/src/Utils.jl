module Utils

using Sockets  # For getting the local IP/hostname of the machine

# Function to generate the hostname with a number suffix, e.g., "Node-01"
function generate_hostname(node_number::Int)
    return @sprintf "Node-%02d" node_number  # Formats the number as two digits
end

# Function to return the current version of the app
# This could be enhanced to fetch the version from a file or environment variable
function get_app_version()
    return "1.0"  # Hardcoded for now, but can be made dynamic
end

# Function to get the local machine's hostname (useful for debugging)
function get_local_hostname()
    return gethostname()
end

end  # module Utils
