# Counts seen classes to identify uniqueness (in at least a single instance).
# This is needed because when using a normal object to create the mapping, the
# class (ie: its name and constructor) are cast to a string, which may conflict.
class ClassMap
  constructor: ->
    @_nextId  = 0
    @_classes = {}

  get: (cls) ->
    cls._honk_clsid or= @_nextId++
    @_classes[cls._honk_clsid]

  set: (cls, instance) ->
    cls._honk_clsid or= @_nextId++
    @_classes[cls._honk_clsid] = instance

module.exports = ClassMap
