
class Injector
  constructor: (@binders...) ->
    @_singletons = {}

  getInstance: (cls) ->
    unless cls.prototype? then throw Error('Could not resolve')
    for binder in @binders
      binding = @_resolve(cls, binding) for binding in binder.bindings
      if binding? then return binding

    @_createNew(cls)

  _createNew: (cls, scope) ->
    if @_singletons[cls] then return @_singletons[cls]
    instance = new cls()
    if scope is 'SINGLETON' or cls.scope is 'SINGLETON'
      @_singletons[cls] = instance
    instance

  _resolve: (cls, binding) ->
    if binding.iface is cls
      @_createNew(binding.impl, binding.iface or binding.impl)

module.exports = Injector
