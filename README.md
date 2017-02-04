# Tenantify

Multitenancy management for Ruby applications.

## Synopsis

Tenantify is a tool to simplify multitenancy on Ruby applications.
It stores the current tenant in a thread variable and provides Resource class
to encapsulate your application resources per tenant (databases, external services,
your own ruby instances, etc)

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
Tenantify.using("the_tenant") { # some code }
```

After that the tenant is set to its previous value.

The using method returns the value returned by the block. If you want to get some data from
a database for a particular tenant:
```ruby
data = Tenantify.using "the_tenant" do
  get_data_from_database
end
```

To get the current tenant `Tenantify.current` is provided.

The `#using` method is the recommended way to run code for a particular tenant, but in some cases it
may be useful to set a tenant as the current one from now on instead of just running a block of code.
For instance, in a pry session:
```ruby
[1] pry(main)> Tenantify.use! "my_tenant"
[2] pry(main)> Tenantify.current
=> "my_tenant"
```

Example to show `Tenantify.using` and `Tenantify.use!` behaviour:
```ruby
# No tenant is set by default
Tenantify.current # => nil

Tenantify.using "tenant_1" do
  Tenantify.current # => "tenant_1"

  # Nested `using` blocks allowed
  Tenantify.using "tenant_2" do
    Tenantify.current # => "tenant_2"

    Tenantify.use! "tenant_3"
    Tenantify.current # => "tenant_3"
  end

  # When a block ends the tenant before the block is set again
  # even if it has changed inside the block due a `use!` call.
  Tenantify.current # => "tenant_1"
end

Tenantify.use! "tenant_4"

# The current tenant is stored as a thread variable. On new threads it has to be set manually.
Thread.new do
  Tenantify.current # => nil
end
Tenantify.current # => "tenant_4"
```

### Resources

On your multitenant application some resources may depend on the current tenant. For instance: A Sequel database,
a Redis database, the host of an external service, etc.

You could handle this situation by calling `Tenantify.current` to determine the resource you need for a tenant.
To avoid having to deal with the current tenant within your app business logic a `Tenantify::Resource` class is
provided.

To build a tenantified resource you have to build a hash that maps the tenant name to the resource for that tenant.
The following example shows how to configure a redis database per tenant on the same host.
```ruby
# when initializing your application:
correspondence = {
  "tenant_1" => Redis.new(:host => "localhost", :port => 6379, :db => 1),
  "tenant_2" => Redis.new(:host => "localhost", :port => 6379, :db => 2)
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
