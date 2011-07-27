Zendesk API Ruby Client [ under development ]
=============================================

Usage
=====

Connection
----------

    # API v1 only supports HTTP Basic Authentication
    @zendesk = Zendesk::Client.new do |config|
      config.account "https://coolcompany.zendesk.com"
      config.basic_auth "email@email.com", "password"
    end

    # API v2 also supports Oauth 2.0
    @zendesk = Zendesk::Client.new do |config|
      config.account "https://support.coolcompany.com"
      config.oauth token, token_secret
    end


Collections
-----------

Collections of resources are fetched as lazily as possible. For example `@zendesk.users` does not hit the API until it is iterated over
(calling `each`) or until an item is asked for (e.g., `@zendesk.users[0]`).

This laziness allows us chain methods in cool ways like:

  * `@zendesk.tickets.create({ ... data ... })`
  * `@zendesk.tickets(123).update({ ... data ... })`
  * `@zendesk.tickets(123).delete`

GET requests are not made until the last possible moment. Calling `fetch` will return the HTTP response (first looking in the cache). If you
want to avoid the cached result you can call `fetch(true)` which will force the client to update its internal cache with the latest HTTP response.

PUT, POST and DELETE requests are issued immediately and respond immediately.

Users
-----

    GET
    @zendesk.users                            # all users in account
    @zendesk.users.each {|user| ..code.. }    # iterate over requested users
    @zendesk.users.per_page(100)              # all users in account (v2 should accept `?per_page=NUMBER`)
    @zendesk.users.page(2)                    # all users in account (v1 currently accepts `?page=NUMBER`)
    @zendesk.users.next_page                  # all users in account (v1 currently accepts `?page=NUMBER`)
    @zendesk.users.current                    # currently authenticated user
    @zendesk.users.me                         # currently authenticated user
    @zendesk.users("Bobo")                    # all users with name matching all or part of "Bobo"
    @zendesk.users(123)                       # return user=123
    @zendesk.users("Bobo", :role => :admin)   # all users with name matching all or part of "Bobo" who are admins
    @zendesk.users(:role => :agent)           # all users who are agents
    @zendesk.users(:role => "agent")          # all users who are agents
    @zendesk.users(:group => 123)             # all users who are members of group id=123
    @zendesk.users(:organization => 123)      # all users who are members of group id=123
    @zendesk.user(123).identities             # all identities in account for a given user

    POST
    A successful POST will return the created user

    # create user from hash
    @zendesk.users.create({:name => "Bobo Yodawg",
                           :email => "bc@email.com",
                           :remote_photo_url => "http://d.com/image.png",
                           :roles => 4})

    # create user with block
    @zendesk.users.create do |user|
      user[:name] = "Bobo Yodawg"
      user[:email] = "bc@email.com"
      user[:remote_photo_url] = "http://d.com/image.png"
      user[:roles] = 4
    end

    PUT
    A successful PUT will return the updated user

    # edit user=123 with hash
    @zendesk.users(123).update({:remote_photo_url => "yo@dawg.com"})

    # edit user=123 with block
    @zendesk.users(123).update do |user|
      user[:remote_photo_url] = "yo@dawg.com"
    end

    @zendesk.users(123).identities.update({:email => "yo@dawg.com"})                    # add email address to user=123
    @zendesk.users(123).identities.update({:email => "yo@dawg.com", :primary => true})  # add email address to user=123

    # add twitter handle to user=123
    @zendesk.users(123).identities.update({:twitter => "yodawg"})

    DELETE
    @zendesk.users(123).delete                                                # deletes user=123

Tickets
-------
    All operations on tickets should be done through the tickets method. The client should hide
    the complexity of "rules", "views", "requests" and be clear about what is happening.
    It would be really good to work through all the best use cases and possibly add methods that
    make sense for tickets, e.g., `@zendesk.tickets(1234).assign(user.id)`

    GET
    @zendesk.tickets                                                           # TODO: not supported currently
    @zendesk.tickets(123)                                                      # return ticket=123

    @zendesk.tickets(:view => 123)                                             # all tickets for view=123
    @zendesk.tickets(:view => "dev")                                           # TODO: not supported currently

    @zendesk.tickets(:tags => ["foo"])                                         # all tickets with tags=foo
    @zendesk.tickets(:tags => ["foo", "bar"])                                  # all tickets with tag=foo OR tag=bar

    @zendesk.tickets(:requester => 123)                                        # all tickets for requester=123
    @zendesk.tickets(:group => 123)                                            # all tickets for group=123
    @zendesk.tickets(:organization => 123)                                     # all tickets for organization=123
    @zendesk.tickets(:assignee => 123)                                         # all tickets for organization=123

    POST
    A successful POST will return the created ticket

    # create ticket from hash
    @zendesk.tickets.create({:description => "phone fell into the toilet",
                            :requester_id => 123,
                            :priority => 4,
                            :set_tags => ["phone", "toilet"]})

    # create ticket with block
    @zendesk.tickets.create do |ticket|
      ticket[:description] = "phone fell into the toilet"
      ticket[:requester_name] = "Snoop Dogg",
      ticket[:requester_email] = "snoop@dogg.com",
      ticket[:priority] = 4,
      ticket[:set_tags] = ["phone", "toilet"]
    end

    # creates new ticket from tweet
    @zendesk.tickets.create({:tweet, :tweet_id => 123456})

    PUT
    A successful PUT will return the updated ticket

    @zendesk.tickets(123).update({:assignee_id => 321})                        # edit ticket (data passed in overrides existing)
    @zendesk.tickets(123).update({:set_tags => ["foo"]})                       # adds tags to ticket
    @zendesk.tickets(123).comment("my comment", {:public => true})             # adds comment to ticket

    DELETE
    @zendesk.tickets(123).delete

Tags
----

    GET
    @zendesk.tags                                                              # 100 most used tags in the account
    @zendesk.tags("foo", :entries)                                             # entries matching tag=foo (limit 15)
    @zendesk.tags("foo", :tickets)                                             # tickets matching tag=foo (limit 15)
    @zendesk.tags("foo", :tickets, :page => 2)                                 # next page of tickets matching tag=foo (limit 15)
    @zendesk.tags(["foo", "bar"], :tickets)                                    # tickets matching tag=foo OR tag=bar (limit 15)

Attachments
-----------
	TODO: later...

    GET

    POST

    PUT

    DELETE

Organizations
-------------
    Organizations are for end-users

    GET
    @zendesk.organizations                                                     # all organizations in account
    @zendesk.organizations(123)                                                # returns organization=123
    @zendesk.oragnizations(123, :users => true)                                # returns organization=123 AND its members

    POST
    A successful POST will return the created organization

    # create organization from hash
    @zendesk.organizations.create({:name => "Fraggle Rock"})

    # create organization with block
    @zendesk.organizations.create do |org|
      org[:name] = "Zoolandia"
      org[:users] = [123, 345]
    end

    PUT
    A successful PUT will return the updated organization

    @zendesk.organizations(123).update({:name => "Soopa Funk"})                # edit name of organization=123
    @zendesk.organizations(123).update({:users => [123, 456]})                 # edit users of organization=123

    DELETE
    @zendesk.organizations(123).delete

Groups
------
    Groups are for Zendesk agents

    GET
    @zendesk.groups                                                            # all organizations in account
    @zendesk.groups(123)                                                       # returns organization=123
    @zendesk.groups(123, :users => true)                                       # returns organization=123 AND its members

    POST
    A successful PUT will return the updated group

    # create group from hash
    @zendesk.groups.create({:name => "Cool People", :agents => [123, 456]})

    # create group with block
    @zendesk.groups.create do |group|
      group[:name] = "Cool People"
      group[:agents] = [123, 456]
    end

    PUT
    A successful PUT will return the updated group

    @zendesk.groups(123).update({:agents => [123, 456]})

    # remove all agents
    @zendesk.groups(123).update({:agents => []})

    DELETE
    @zendesk.groups(123).delete

Forums
------
    Still wresting with how to best represent forums/entries in the client library.

    GET
    @zendesk.forums                                          # all forums in account
    @zendesk.forums(123)                                     # returns forum=123
    @zendesk.forums(123).entries                             # returns all entries for forum=123

    POST
    A successful POST will return the created forum

    # create forum from hash
    @zendesk.forums.create({:name => "FAQ",
                            :description => "get your Q's A'd",
                            :locked => false,
                            :visibility => 1})

    # create forum with block
    @zendesk.forums.create do |forum|
      forum[:name] = "FAQ"
      forum[:description] = "get your Q's A'd"
      forum[:locked] = false
      forum[:visibility] = 1
    end

    @zendesk.forums.add_entry(123, :title => "stuff",                           # creates new entry for forum=123
                                  :body => "and stuff",
                                  :pinned => true,
                                  :locked => false
                                  :tags => ["foo", "bar"])

    PUT
    A successful POST will return the created forum or entry

    @zendesk.forum_update(123, :public => false)                               # edit forum=123
    @zendesk.forum_entry_update(123, :public => false)                         # edit forum=123

    DELETE
    @zendesk.forum_delete(123)                                                 # deletes forum=123 AND related posts and comments

Search
------

    GET

    POST

    PUT

    DELETE

Ticket Fields
-------------

    GET

    POST

    PUT

    DELETE

Macros
------

    GET

    POST

    PUT

    DELETE

