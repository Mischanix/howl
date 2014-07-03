{
  Object: (o, base, meta = {}) ->
    props = base.properties

    meta.__index = (o, k) ->
      m = base[k]
      return m if m
      p = props[k]
      p = p.get if type(p) == 'table'
      p and p o

    meta.__newindex = (o, k, ...) ->
      p = props[k]
      p = p.set if p
      p and p o, ...

    setmetatable o, meta
}