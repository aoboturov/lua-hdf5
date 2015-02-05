------------------------------------------------------------------------------
-- Testing tools.
-- Copyright © 2013–2014 Peter Colberg.
-- Distributed under the MIT license. (See accompanying file LICENSE.)
------------------------------------------------------------------------------

require("strict")

local hdf5 = require("hdf5")

local _M = {}

do
  local maj_ver, min_ver, rel_ver = hdf5.get_libversion()
  function _M.require_version(maj, min, rel)
    return maj_ver > maj or maj_ver == maj and (min_ver > min or min_ver == min and rel_ver >= rel)
  end
end

assert(_M.require_version(1, 8, 0))

return _M
