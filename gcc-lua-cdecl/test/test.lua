--
-- Testing tools.
-- Copyright © 2013–2015 Peter Colberg.
-- Distributed under the MIT license. (See accompanying file LICENSE.)
--

local _M = {}

-- Raises an error unless the given values compare equal.
function _M.assert_equal(a, b)
  if a == b then return end
  if type(a) == "string" then a = ("%q"):format(a) end
  if type(b) == "string" then b = ("%q"):format(b) end
  error(("assertion failed [%s != %s]"):format(a, b), 2)
end

return _M
