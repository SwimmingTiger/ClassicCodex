function printf(...)
    print(string.format(...))
end

function eprintf(...)
    io.stderr:write(string.format(...))
    io.stderr:write("\n")
end
