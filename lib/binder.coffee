
class Binding
  constructor: (@iface) ->
    if @iface.scope? then @inScope(@iface.scope)

  to: (impl) ->
    if @impl? then throw Error('Already bound')
    @impl = impl
    if impl.scope? then @scope = impl.scope.toUpperCase()
    this

  inScope: (scope) ->
    if @scope? and @scope isnt scope
      throw Error("Already scoped to #{@scope}")

    switch scope.toUpperCase()
      when 'SINGLETON' then @scope = 'SINGLETON'
      when 'INSTANCE' then # Just ignore
      else throw Error("Invalid scope, '#{scope}'")
    this


class Binder
  constructor: ->
    @bindings = []
    @configure()

  bind: (iface) ->
    binding = new Binding(iface)
    @bindings.push(binding)
    binding


module.exports = Binder
