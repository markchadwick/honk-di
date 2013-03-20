
class Injector
  constructor: (@binders...) ->
    @_singletons = {}

  getInstance: (cls, args...) ->
    unless cls.prototype? then throw Error('Could not resolve')
    for binder in @binders
      binding = @_resolve(cls, binding) for binding in binder.bindings
      if binding? then return binding

    @_createNew(cls, undefined, args...)

  _createNew: (cls, scope, args...) ->
    if @_singletons[cls] then return @_singletons[cls]
    instance = new cls(args...)
    @_populate(instance)
    if scope is 'SINGLETON' or cls.scope is 'SINGLETON'
      @_singletons[cls] = instance
    instance

  _resolve: (cls, binding) ->
    if binding.iface is cls
      @_createNew(binding.impl, binding.iface or binding.impl)

  _populate: (instance) ->
    for k, v of instance
      continue unless v? and v._requiresInjection_
      instance[k] = @getInstance(v.cls, v.args...)

module.exports = Injector
