
-- ======== PROBLEM ==========

lightspeed = 1.0

-- === SETTINGS ===

verbosity = 1
cfl = 0.5
time_integration_scheme = 'euler'

-- === GEOMETRY ===

refine_cutcells = true

merge_fraction = 0.5

svg = ReadSVG.new('stealth_2.svg', 0.01)

function svg1(x, y)
  return -svg:query(x, y,'/Layer 1')
end

function svg2(x, y)
  return -svg:query(x, y,'/Layer 2')
end

function svg3(x, y)
  return -svg:query(x, y,'/Layer 3')
end

embedded_boundaries = {

--[[
  circle = {
    geom=svg1,
    bcs={field={type='conductor'},
    },
    boolean_operation='or',
    inside=1,
  },

  funky = {
    geom=svg2,
    bcs={field={type='conductor'},
    },
    boolean_operation='and',
    inside=1,
  },
--]]

  jet = {
    geom=svg3,
    bcs={field={type='conductor'},
    },
    boolean_operation='and',
    inside=1,
  },

}

-- === DEFINE STATES ===

states = {

  field = {
      type='field',
      reconstruction='O6', 
      flux='RankineHugoniot',
      value = {
          x_D = function(dat) return math.exp(-100.0*(dat['y']-3.5)^2)*math.cos(dat['y']*3.14159265) end,
      },
      refinement={name='field_value', x_D=0.005, y_D=0.005, min_value=0.0001},
  }
}

-- === DEFINE ACTIONS ===

actions = {

fluxes = {
  type = 'CTU',
  corner_transport=true,
  states = {'field'},
},

}
