# Nano RPC

An RPC wrapper for Nano digitial currency nodes. Arbitrary RPC access is provided along with proxy objects that expose helper methods ([Wiki](https://github.com/jcraigk/ruby_nano_rpc/wiki/Proxy-Object-Reference)).

To run a Nano node locally, see [Nano Docker Docs](https://github.com/clemahieu/raiblocks/wiki/Docker-node).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'nano_rpc'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install nano_rpc

## Usage

There are two ways to use this gem.  You can make direct calls to the RPC client using Ruby hashes or you can use proxy objects for terser code.

### Raw RPC Calls

The RCP client exposes raw Remote Procedure Call methods according to the [Nano RPC Docs](https://github.com/clemahieu/raiblocks/wiki/RPC-protocol).

Every method requires an `action`, which is passed as the first argument to `call`.  Depending on the action, there may be additional required or optional parameters that are passed as an options hash.

First setup the client:

```ruby
# Connect to localhost:7076
client = Nano.client

# Connect to custom host
client = Nano::Client.new(host: 'mynanonode', port: 1234)
```

Then make a `call`, passing the action and data:

```ruby
  client.call(:account_balance, account: 'xrb_someaddress1234')
  # => {"balance"=>100, "pending"=>0}
````

Response data are provided as [Hashie](https://github.com/intridea/hashie) objects with integer coercion, indifferent access, and method access.

```ruby
  data = client.call(:account_balance, account: 'xrb_someaddress1234')
  # => {"balance"=>100, "pending"=>0}
  data.balance
  # => 100
  data[:balance]
  # => 100
  data['balance']
  # => 100
````

### Proxy Objects

Proxy objects are provided to ease interaction with the API by providing logically grouped helper methods. Here we do not strictly follow the grouping as expressed in the [Nano RPC Docs](https://github.com/clemahieu/raiblocks/wiki/RPC-protocol).  Instead, the following objects are provided:

```ruby
  Nano::Account
  Nano::Accounts
  Nano::Node
  Nano::Wallet
```

`Account`, `Accounts`, and `Wallet` each require a single parameter to be passed during initialization.  This parameter is persisted for subsequent calls.  All RPC methods are provided directly as methods.

```ruby
  account = Nano::Account.new('xrb_someaddress1234')

  account.account_balance
  # => {"balance"=>100, "pending"=>0}
  account.account_balance.balance
  # 100
```

You can ask an object what raw RPC methods it provides using `proxy_methods`:

```ruby
  account.proxy_methods
  # => [:account_balance, :account_block_count, :account_create, ...]
```

There are also helper methods for terser code:

```ruby
  account = Nano::Account.new('xrb_someaddress1234')
  account.balance
  # 100
  account.pending_balance
  # 0
```

`Node` methods are provided at both the instance and class levels:

```ruby
  Nano::Node.version
  # => {"rpc_version"=>1, "store_version"=>10, "node_vendor"=>"RaiBlocks 9.0"}

  node = Nano::Node.new
  node.version.rpc_version
  # => 1
  node.peers
  # => {"[::ffff:2.80.5.202]:64317"=>"5", "[::ffff:2.249.74.58]:7075"=>"5", "[::ffff:5.9.31.82]:7077"=>"4", ... }
  node.available_supply
  # => {"available"=>132596127030666124778600855847014518457}
  node.available
  # => 132596127030666124778600855847014518457
  node.block_count.unchecked
  # => 4868605
```

You can point each proxy object at its own node by passing a custom client in:

```ruby
  client = Nano::Client.new(host: 'mynanonode', port: 1234)
  account = Nano::Account.new('xrb_someaddress1234', client: client)
```

For a more comprehensive guide, see the [Wiki](https://github.com/jcraigk/ruby_nano_rpc/wiki/Proxy-Object-Reference).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
