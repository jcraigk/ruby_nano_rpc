# RaiBlocksRpc

An RPC wrapper for RaiBlocks written in Ruby.  It connects to an individual node that you control.  There's a client object you can use to make explicit RPC calls as well as proxy objects with logically grouped methods.

To run a RaiBlocks node locally, see [Docker documentation](https://github.com/clemahieu/raiblocks/wiki/Docker-node).

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

There are two ways to use this gem.  You can make direct calls to the RPC client or use the provided proxy objects.

In either case, the client should first be configured to connect to a RaiBlocks node.  If you do not specify host or port before using the client, then `localhost:7076` will be used by default.

```ruby
  RaiblocksRpc::Client.host = 'localhost'
  RaiblocksRpc::Client.port = 7076
````

### Raw RPC Calls

You can use the RPC client to make raw RPC calls to a RaiBlocks node according to the [documentation](https://github.com/clemahieu/raiblocks/wiki/RPC-protocol).

Every call requires an `action`, which is passed as the first argument to `call`.  Depending on the action, there may be additional required or optional parameters that are passed as an options hash.

```ruby
  RaiblocksRpc::Client.new.call(:account_balance, account: 'xrb_someaddress1234')
  # => {"balance"=>100, "pending"=>0}
````

Response data are provided as `Hashie` objects with integer coercion, indifferent access, and method access included so you have several options for accessing values.

```ruby
  data = RaiblocksRpc::Client.new.call(:account_balance, account: 'xrb_someaddress1234')
  # => {"balance"=>100, "pending"=>0}
  data.balance
  # => 100
  data[:balance]
  # => 100
  data['balance']
  # => 100
````

### Proxy Objects

A few proxy objects are provided as a means to logically group RPC calls. Here we do not strictly follow the grouping as expressed in the [RaiBlocks RPC documentation](https://github.com/clemahieu/raiblocks/wiki/RPC-protocol).  Instead, the following objects are provided:

```ruby
  RaiblocksRpc::Account # { account: 'xrb_address12345' }
  RaiblocksRpc::Accounts # { accounts: ['xrb_address12345', 'xrb_address67890] }
  RaiblocksRpc::Wallet # { wallet: 'F3093AB' }
  RaiblocksRpc::Network
  RaiblocksRpc::Node
  RaiblocksRpc::Util
```

`Account`, `Accounts`, and `Wallet` each require parameters to be passed during initialization.  You can then make calls on these objects without needing to pass in the params for subsequent calls.

Methods whose prefix matches the class name, such as `account_balance`, also have an abbreviated version, in this case `balance`.


```ruby
  account = RaiblocksRpc::Account.new('xrb_someaddress1234')

  account.balance
  # => {"balance"=>100, "pending"=>0}
  account.account_balance
  # => {"balance"=>100, "pending"=>0}
```

Some methods appear on multiple objects for convenience.

```ruby
  RaiblocksRpc::Node.new.block_count
  # => {"count"=>314848, "unchecked"=>4793586}

  RaiblocksRpc::Network.new.block_count
  # => {"count"=>314848, "unchecked"=>4793642}
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
