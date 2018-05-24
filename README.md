[![Maintainability](https://api.codeclimate.com/v1/badges/a99a88d28ad37a79dbf6/maintainability)](https://codeclimate.com/github/codeclimate/codeclimate/maintainability)

![Ruby Nano RPC Logo](https://i.imgur.com/ihmmYcp.png)

Nano RPC is a Ruby wrapper for making Remote Procedure Calls against Nano digital currency nodes. Arbitrary RPC access is provided along with proxy objects that expose helper methods ([Wiki](https://github.com/jcraigk/ruby_nano_rpc/wiki)).

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

There are two ways to use this gem.  You can make direct RPC calls using Ruby hashes or you can use proxy objects for terser code.

### Raw RPC Calls

The NanoRpc::Node object exposes raw Remote Procedure Call methods according to the [Nano RPC Docs](https://github.com/clemahieu/raiblocks/wiki/RPC-protocol).

Every method requires an `action`, which is passed as the first argument to `call`.  Depending on the action, there may be additional required or optional parameters that are passed as an options hash.

First setup the node connection:

```ruby
# Connect to the default node (localhost:7076)
node = NanoRpc.node

# or connect to a custom node
node = NanoRpc::Node.new(host: 'mynanonode', port: 1234)
```

If you're using [Nanode](https://www.nanode.co/) or similar service that requires `Authorization` key in HTTP header, you can specify it using `auth`.

```ruby
node = NanoRpc::Node.new(auth: 'someauthkey')
```

You can also specify custom headers as a hash. These will be sent with every RPC request.

```ruby
node = NanoRpc::Node.new(headers: { 'Authorization' => 'someauthkey' })
```

Once the node is setup, make a `call`, passing the action and data:

```ruby
node.call(:account_balance, account: 'xrb_someaddress1234')
# => {"balance"=>100, "pending"=>0}
````

Response data are provided as [Hashie](https://github.com/intridea/hashie) objects with integer coercion, indifferent access, and method access.

```ruby
  data = node.call(:account_balance, account: 'xrb_someaddress1234')
  # => {"balance"=>100, "pending"=>0}
  data.balance
  # => 100
  data[:balance]
  # => 100
  data['balance']
  # => 100
````

### Proxy Objects / Helper Methods

Proxy objects are provided to ease interaction with the API by providing logically grouped helper methods. Here we do not strictly follow the grouping as expressed in the [Nano RPC Docs](https://github.com/clemahieu/raiblocks/wiki/RPC-protocol).  Instead, the following objects are provided:

* [NanoRpc::Account](https://github.com/jcraigk/ruby_nano_rpc/wiki/NanoRpc::Account)
* [NanoRpc::Accounts](https://github.com/jcraigk/ruby_nano_rpc/wiki/NanoRpc::Accounts)
* [NanoRpc::Node](https://github.com/jcraigk/ruby_nano_rpc/wiki/NanoRpc::Node)
* [NanoRpc::Wallet](https://github.com/jcraigk/ruby_nano_rpc/wiki/NanoRpc::Wallet)

`Account`, `Accounts`, and `Wallet` each require a single parameter to be passed during initialization (`address`, `addresses`, and `seed`, respectively).  This parameter is persisted for subsequent calls.  All RPC methods are provided directly as methods.

```ruby
  account = NanoRpc::Account.new('xrb_someaddress1234')

  account.account_balance
  # => {"balance"=>100, "pending"=>5}
  account.account_balance.balance
  # => 100
```

There are also helper methods to bypass repetitive nested calls:

```ruby
  account.balance
  # => 100
  account.pending_balance
  # => 5
```

You can point each proxy object at its own node by passing in a node instance:

```ruby
node = NanoRpc::Node.new(host: 'mynanonode', port: 1234)
account = NanoRpc::Account.new('xrb_someaddress1234', node: node)
```

Or, easier, you can access acounts and wallets from the node itself:

```ruby
account = node.access_account('xrb_someaddress1234')
wallet = node.access_wallet('3AF91AE')
```

For a comprehensive guide, see the [Wiki](https://github.com/jcraigk/ruby_nano_rpc/wiki).

## Credits

Logo created by Andrei Luca ([Twitter](https://twitter.com/lucandrei_))

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
