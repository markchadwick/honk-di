# Honk! DI!
`honk-di` is a [Guice](https://code.google.com/p/google-guice/)-like dependency
injector for (Java|Coffee)Script.

## The Injector
The injector creates classes and resolves their dependencies. Take the
following.

```coffeescript
class User
  say: (name) -> console.log "hi, #{name}"

injector = new inject.Injector()
user1 = injector.getInstance(User)
user2 = injector.getInstance(User)

assert user1 !== user2
```

But what if we want only one User? We scope it!
```coffeescript
class User
  @scope: 'singleton'

  say: (name) -> console.log "hi, #{name}"

injector = new inject.Injector()
user1 = injector.getInstance(User)
user2 = injector.getInstance(User)

assert user1 === user2
```

## Dependencies
Making a single class isn't going to save you much. What you want is for it to
resolve your dependencies.

```coffeescript
inject = require 'honk-di'

class Sayer
  @scope: 'singleton'

  say: (name) -> console.log "hi, #{name}"

class User
  sayer: inject(Sayer)

  say: (name) -> @sayer.say(name)

injector = new inject.Injector()
user     = inject.getInstance(User)
sayer    = inject.getInstance(Sayer)

user.say('Jimmy')
> Hi, jimmy
user.sayer === sayer
> True
```
Note how DI's managed the singleton scope of the sayer for us. If we pulled out
another `User` from the injector, it would be a new instance with the same
instance to `Sayer`

## Binders
A binder is analogous to a Guice Module. But, seeing how "module" means
something in the ol' Node.js world, they're called binders here.

Sometimes your dependencies get more complicated. Like, you may have a `MapView`
that's just an in-memory mock for your test, but uses Google Maps in the UI, and
you're working on porting them to Leaflet. You can control this kind of malarkey
with DI pretty well.

```coffeescript
inject = require 'honk-di'

class ProductionEnv extends inject.Binder
  configure:
    @bind(MapView).to(GoogleMapView)
    @bind(UserStore).to(MemUserStore).inScope('singleton')
    @bindConstant('api.root').to('/api/v1')
```

Now, the injector may consult some number of `Binder`s before creating an
instance. Say we have a controller as follows:

```coffeescript
class Sayer
  @scope: 'singleton'

  say: (name) -> console.log "hi, #{name}"

class MapController
  view:     inject(MapView)
  users:    inject(UserStore)
  apiRoot:  inject('api.root')

  render: ->
    $.get("#{apiRoot}/users")
      .then((users) -> @users.reset(user))
      .done((users) -> @view.render(users))
```

## What's missing
Providers, complex scopes. I'm sure plenty of other small weird things.

## Good Ideas
The best DI apps have one call to `injector.getInstance`. Passing the injector
around or pulling many instances out of it is likely a bad sign. Try to express
hairy sections as classes that have some number of dependencies and let DI
figure it out for you.
