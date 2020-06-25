function table.find(where, element)
  for key, value in pairs(where) do
    if value == element then
      return key
    end
  end

  return false
end