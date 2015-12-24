# Tenantify

This gem provides some tools to manage multitenancy on Ruby applications.

## Synopsis

Tenantify is a tool to simplify multitenancy on Ruby applications.
It stores the current tenant in a thread variable and provides:

  - A Rack middleware supporting some built-in and custom strategies to find a tenant
    and set it as the current one for a request.

  - A Resource class to encapsulate your application resources per tenant (databases,
    external services, your own ruby instances, etc)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'tenantify'
```

And then execute:

    $ bundle

## Usage

### The current tenant

Tenantify provides some class methods to set the current tenant for a piece of code.

To execute some code for a particular tenant:
```ruby
Tenantify.using(:the_tenant) { # some code }
```

After that the tenant is set to its previous value.

The using method returns the value returned by the block. If you want to get some data from
a database for a particular tenant:
```ruby
data = Tenantify.using :the_tenant do
  get_data_from_database
end
```

To get the current tenant `Tenantify.current` is provided.

The `#using` method is the recommended way to run code for a particular tenant, but in some cases
may be useful to set a tenant as the current one from now on instead of just running a block of code.
For instance, in a pry session:
```ruby
[1] pry(main)> Tenantify.use! :my_tenant
[2] pry(main)> Tenantify.current
=> :my_tenant
```

Example to show `Tenantify.using` and `Tenantify.use!` behaviour:
```ruby
# No tenant is set by default
Tenantify.current # => nil

Tenantify.using :tenant_1 do
  Tenantify.current # => :tenant_1

  # Nested `using` blocks allowed
  Tenantify.using :tenant_2 do
    Tenantify.current # => :tenant_2

    Tenantify.use! :tenant_3
    Tenantify.current # => :tenant_3
  end

  # When a block ends the tenant before the block is set again
  # even if it has changed inside the block due a `use!` call.
  Tenantify.current # => :tenant_1
end

Tenantify.use! :tenant_4

# The current tenant is stored as a thread variable. On new threads it has to be set manually.
Thread.new do
  Tenantify.current # => nil
end
Tenantify.current # => :tenant_4
```

### Resources

On your multitenant application some resources may depend on the current tenant. For instance: A Sequel database,
a redis database, the host of an external service, etc.

You could handle this situation by calling `Tenantify.current` to determine the resource you need for a tenant.
To avoid having to deal with the current tenant within your app business logic a `Tenantify::Resource` class is
provided.

To build a tenantified resource you have to build a hash that maps the tenant name to the resource for that tenant.
The following example shows how to configure a redis database per tenant on the same host.
```ruby
# when initializing your application:
correspondence = {
  :tenant_1 => Redis.new(:host => "localhost", :port => 6379, :db => 1),
  :tenant_2 => Redis.new(:host => "localhost", :port => 6379, :db => 2)
}

redis_resource = Tenantify.resource(correspondence)
Object.const_set("Redis", redis_resource)


# at the entry point of your application
tenant_name = find_out_current_tenant
Tenantify.using(tenant_name) { app.run }


# anywhere inside your app
Redis.current # => Returns the redis instance for the current tenant
```

You can build a resource for any multitenant resource you have on your application.

### The Rack middleware

You can use Tenantify with any Ruby application you like and set the current tenant as soon as you know it,
ideally outside of the boundaries of your application business logic.

On a Rack application, this place is somewhere in the middleware stack. To handle this situation Tenantify
provides a `Tenantify::Middleware`.

There are several strategies you could use to choose the tenant to work with from the Rack environment.
Tenantify has some basic built-in strategies, but you might want to implement your custom ones to handle
more specific situations.

The built-in strategies are:

  * The `:header` strategy expects the tenant name to be sent in a request header.
  * The `:host` strategy expects a hash with tenants as keys, and arrays of hosts as values.
  * The `:default` strategy always returns the same tenant.

You can configure Tenantify to use one or more strategies.

The following example configures Tenantify to:

  * Check the "X-Tenant" header to look for a tenant.
  * If the header does not exist, select a tenant associated to the current host.
  * If no tenant provided for the current host, use de tenant: `:main_tenant`

```ruby
# when initializing your application
hosts_per_tenant = {
  :tenant_1 => ["www.host_a.com", "www.host_b.com"],
  :tenant_2 => ["www.host_c.com"]
}

Tenantify.configure do |config|
  config.strategy :header, :name => "X-Tenant"
  config.strategy :hosts, hosts_per_tenant
  config.strategy :default, :tenant => :main_tenant
end


# on your config.ru
use Tenantify::Middleware
run MyRackApplication
```
