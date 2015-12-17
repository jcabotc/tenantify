# Tenantify

This gem provides some tools to manage multitenancy on Rack applications

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'tenantify', :git => 'https://bitbucket.org/qustodian/tenantify.git'
```

And then execute:

    $ bundle

## Usage

### Configuration

To configure Tenantify for your application:

```ruby
Tenantify.configure do |config|
  config.configuration_path = "my/custom/configuration.yml"
  config.environment        = ENV["RACK_ENV"]
end
```

### Middleware

The first step is to configure your Rack application to use the middleware. You can do so adding the following line to your `config.ru`:

```ruby
# ... your code
use Tenantify::Middleware

run YourRackApplication
```

The middleware sets the current tenant based on 2 sources (in order of priority):

  1. The value of the header `X-Tenant` in the Rack environment

  2. The tenant associated to the domain of the request in the configuration file (`config/tenants.yml` by default)

### The configuration file

The configuration file is needed if you expect to use the domain-tenant functionality.
By default it expects the tenants configuration to be in `config/tenants.yml`. If you want to provide your custom configuration file, you can inject the configuration yourself:

```ruby
Tenantify.configure do |config|
  config.configuration_path = "my/custom/configuration.yml"
end
```

The file must have the following keys:

```yaml
tenant_name_1:
  hosts:
    - www.first_host_for_tenant_1.com
    - www.second_host_for_tenant_1.com

tenant_name_2:
  hosts:
    - www.host_for_tenant_2.com

# more tenants configuration
```

If you are working on multiple environments and do you want a tenants configuration per environment set the environment in the configuration block, and nest the tenants configuration under each environment in your configuration file:

```ruby
Tenantify.configure do |config|
  config.environment = ENV["RACK_ENV"]
end
```

The file must have the following keys:

```yaml
test:
  single_tenant:
    hosts:
      - localhost
      - www.example.com

production:
  tenant_name_1:
    hosts:
      - www.first_host_for_tenant_1.com
      - www.second_host_for_tenant_1.com

  tenant_name_2:
    hosts:
      - www.host_for_tenant_2.com

# more environments configuration
```

### The managers

Managers are instances of `Tenantify::Manager` that represent a system resource that is different for each tenant.
For example, imagine you need a different redis instance for each tenant:

```ruby
tenant_1_redis = Redis.new(:url => "redis://...") # => #<Redis client 1>
tenant_2_redis = Redis.new(:url => "redis://...") # => #<Redis client 2>

correspondence = {
  "tenant_1" => tenant_1_redis,
  "tenant_2" => tenant_2_redis
}

Redis = Tenantify::Manager.new(correspondence)

# It forces the block to use a tenant (used internally by the middleware)
Tenantify::Perform.with "tenant_2" do
  Redis.current # => <#Redis client 2>
end

# Iterates over all tenants and its associated resources
Redis.each do |tenant, redis_instance|
  puts "#{ tenant }: #{ redis_instance }"
end
# It puts:
#  "tenant_1: <#Redis client 1>"
#  "tenant_2: <#Redis client 2>"
```
