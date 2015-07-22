compare = (a,s_or_reg) ->
  if s_or_reg instanceof RegExp then s_or_reg.test(a)
  else s_or_reg == a

one_or_none = (collection, lookFor) ->
  [value, rest...] = collection.filter (key) -> compare(key, lookFor)
  #console.log [value, rest, lookFor, collection]
  if value? and not rest.length then value
  else if rest.length then throw new Error("ambiguous property")
  else undefined

module.exports.SmartProp = class SmartProp
  constructor : (prop) ->
    @prop = prop
    this.cache = []
    this.foundOnce = false

  ###*
  @param collection : Object
  @param prop : String
  @param [name] : String
  ###
  get : (collection) ->
    if not @foundOnce then @_get(collection)
    else
      result = collection;
      @cache.map (step) -> result = result[step]
      result
  _get : (collection) ->
    self = @
    #if there are just 2 params given
    keys = Object.keys(collection)
    knv = keys.map (key) -> [key, collection[key]]
    res = one_or_none(keys, self.prop)

    if !res
      #console.log("nested")
      multi = (knv.filter ([k,v]) -> (typeof v) == "object").map ([k,v]) ->
        self.cache.push(k);
        self._get(v)
      #console.log "multi"
      #console.log multi
      if !multi.length then null
      else if multi.length == 1
        self.foundOnce = true
        multi[0]
      else throw new Error("ambiguous property")
    else
      self.cache.push(res)
      collection[res]

mapObject = (obj, fn) ->
  newobj = {}
  Object.keys(obj).map (key) ->
    val = obj[key]
    if typeof val == "object" and not val instanceof RegExp then newobj[key] = mapObject(val, fn)
    else newobj[key] = fn(key, val)
  newobj

assignObject = (from, to) ->
  newobj = {}
  Object.keys(to).map (key) ->
    val = to[key]
    if typeof val == "object" and not val instanceof RegExp then newobj[key] = val.get(from)
    else newobj[key] = val.get(from)
  newobj

module.exports.SmartObject = class SmartObject
  constructor : (obj) ->
    this.obj = mapObject obj, (key, value) -> new SmartProp(value)

  map :(target) ->
    assignObject(target, this.obj)


