classMapId = 0

# Counts seen classes to identify uniqueness (in at least a single instance).
# This is needed because when using a normal object to create the mapping, the
# class (ie: its name and constructor) are cast to a string, which may conflict.
class ClassMap
  constructor: ->
    @_nextId  = 0
    @_classes = {}
    @_field   = "_honk_clsid_#{classMapId++}"

  get: (cls) ->
    @_classes[cls[@_field]]

  set: (cls, instance) ->
    cls[@_field] or= "#{@_id}-#{@_nextId++}"
    @_classes[cls[@_field]] = instance

module.exports = ClassMap
