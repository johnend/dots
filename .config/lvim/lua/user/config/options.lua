local options = {
 guicursor = "v:hor20,i:ver30",
}

for k, v in pairs(options) do
  vim.opt[k] = v
end

