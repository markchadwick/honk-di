
class Injection

  constructor: (@binders) ->
    @_stack = []

  get: (cls, args...) ->
    @_stack.push(name(cls))
    try
      bound = @_binderResolve(cls)
      if bound? then return bound

      unless cls.prototype?
        @_error()

      @_createNew(cls, undefined, args...)

    finally
      @_stack.pop()

  _binderResolve: (cls) ->
    for binder in @binders
      for binding in binder.bindings
        instance = @_resolve(cls, binding)
        if instance? then return instance

  _error: ->
    throw Error("Could not resolve: #{@_stack.join(' -> ')}")

module.exports = Injection
