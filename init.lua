local path = ({...})[1]:gsub("%.init", "")
require(path .. ".input")
