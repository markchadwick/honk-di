ClassMap = require './class_map'

name = (injectable) ->
  if injectable.name? then injectable.name
  else "'#{injectable}'"

class Injector
  constructor: (@binders...) ->
    @_singletons = new ClassMap()
    @_stack = []

  getInstance: (cls, args...) ->
    @_stack.push(name(cls))

    try
      for binder in @binders
        for binding in binder.bindings
          instance = @_resolve(cls, binding)
          if instance? then return instance

      unless cls.prototype?
        throw Error("Could not resolve: #{@_stack.join(' -> ')}")
      @_createNew(cls, undefined, args...)

    finally
      @_stack.pop()

  _createNew: (cls, scope, args...) ->
    if cls is Injector then return this
    singleton = @_singletons.get(cls)
    if singleton? then return singleton

    ptype = ->
    ptype.prototype = cls.prototype
    instance = new ptype()
    @_injectFields(cls.prototype, instance)
    cls.apply(instance, args)

    if scope?.toUpperCase?() is 'SINGLETON' or cls.scope?.toUpperCase?() is 'SINGLETON'
      @_singletons.set(cls, instance)

    instance

  _resolve: (cls, binding) ->
    if binding.matches(cls)
      defaultFactory = =>
        @_createNew(binding.impl, binding.scope)
      binding.create(defaultFactory)

  _injectFields: (ptype, instance) ->
    for k, v of ptype
      if v? and v._requiresInjection_
        instance[k] = @getInstance(v.cls, v.args...)

module.exports = Injector
