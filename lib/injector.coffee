class Injector
  constructor: (@binders...) ->
    @_singletons = {}

  getInstance: (cls, args...) ->
    for binder in @binders
      binding = @_resolve(cls, binding) for binding in binder.bindings
      if binding? then return binding

    unless cls.prototype? then throw Error('Could not resolve')
    @_createNew(cls, undefined, args...)

  _createNew: (cls, scope, args...) ->
    if cls is Injector then return this
    if @_singletons[cls] then return @_singletons[cls]

    ptype = ->
    ptype.prototype = cls.prototype
    instance = new ptype()
    @_injectFields(cls.prototype, instance)
    cls.apply(instance, args)

    if scope?.toUpperCase?() is 'SINGLETON' or cls.scope?.toUpperCase?() is 'SINGLETON'
      @_singletons[cls] = instance

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
