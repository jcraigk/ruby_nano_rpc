# Raiblocks RPC

An RPC wrapper for RaiBlocks written in Ruby.  It connects to an individual node that you control.  There's a client object you can use to make explicit RPC calls as well as proxy objects with logically grouped convenience methods.

To run a RaiBlocks node locally, see [RaiBlocks Docker Docs](https://github.com/clemahieu/raiblocks/wiki/Docker-node).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'raiblocks_rpc'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install raiblocks_rpc

## Usage

There are two ways to use this gem.  You can make direct calls to the RPC client using Ruby hashes or you can use proxy objects for terser code.

### Raw RPC Calls

The RCP client exposes raw Remote Procedure Call methods according to the [RaiBlocks RPC Docs](https://github.com/clemahieu/raiblocks/wiki/RPC-protocol).

Every method requires an `action`, which is passed as the first argument to `call`.  Depending on the action, there may be additional required or optional parameters that are passed as an options hash.

First setup the client:

```ruby
# Connect to localhost:7076
client = Raiblocks.client

# Connect to custom host
client = Raiblocks::Client.new(host: 'myraiblocksnode', port: 1234)
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

Proxy objects are provided to ease interaction with the API by providing logically grouped helper methods. Here we do not strictly follow the grouping as expressed in the [RaiBlocks RPC Docs](https://github.com/clemahieu/raiblocks/wiki/RPC-protocol).  Instead, the following objects are provided:

```ruby
  Raiblocks::Account # { account: 'xrb_address12345' }
  Raiblocks::Accounts # { accounts: %w[xrb_address12345 xrb_address67890] }
  Raiblocks::Node
  Raiblocks::Wallet # { wallet: 'F3093AB' }
```

`Account`, `Accounts`, and `Wallet` each require a single parameter to be passed during initialization.  This parameter is persisted for subsequent calls.  All RPC methods are provided directly as methods.

```ruby
  account = Raiblocks::Account.new('xrb_someaddress1234')

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
  account = Raiblocks::Account.new('xrb_someaddress1234')
  account.balance
  # 100
  account.pending_balance
  # 0
```

You can ask an object what helper methods it provides using `helper_methods` (coming soon):

```ruby
  account.helper_methods
  # => [:balance, :pending_balance, ...]
```

`Node` methods are provided at both the instance and class levels:

```ruby
  Raiblocks::Node.version
  # => {"rpc_version"=>1, "store_version"=>10, "node_vendor"=>"RaiBlocks 9.0"}

  node = Raiblocks::Node.new
  version.rpc_version
  # => 1
  node.peers
  # => {"peers"=>{"[::ffff:2.80.5.202]:64317"=>"5", "[::ffff:2.249.74.58]:7075"=>"5", "[::ffff:5.9.31.82]:7077"=>"4", ... }
  node.available_supply
  # => {"available"=>132596127030666124778600855847014518457}
  node.block_count.unchecked
  # => 4868605
```

To connect to a custom node, instantiate a client and pass it into the proxy object as `client`:

```ruby
  client = Raiblocks::Client.new(host: 'myraiblocksnode', port: 1234)
  account = Raiblocks::Account.new('xrb_someaddress1234', client: client)
```

For a more comprehensive guide, see the [Wiki](https://github.com/jcraigk/ruby_raiblocks_rpc/wiki).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
