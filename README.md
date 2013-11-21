ServiceAdvertisement
====================

Service Advertisement Protokoll and Reference Implementation.



What is it about?
-----------------

We aim to create a simple Network Protocol that allows service providers to publish the existence of there services. The Network Protokoll has to provide the following features:
- decentralised: every Advertisementserver is equal. There is no hirachy.
- simple: easy to implement and to use.
- powerfull: alot of complex operations are supposed to be implementable ontop the protocols datastructure
- independace of other network protocols: the Protocol is supposed to be indifferent of the exact way of communication used.

Why do we want to do this?
--------------------------

Currently there is a need for a connection between different decentralised Networks. The Problem is a unique Identification of services in order to find them in a reliable and fast manner. We aim to fill the gab by providing a way to find services relatively fast. We think that it is not worth the effort to provide totally unique and human readable identification like DNS in a decentraliced manner.

The basic Idea?
---------------

Who ever has a service can go to any advertisementserver and ask them to publish their existence. Now everyone can ask the advertisementserver for the services he knows. Those informations can now be filtered localy. Advertisementservers also publish their existence over other advertisementservers and maybe even their most important ads.

Both servers and clients are able to do more complex thinks using the basic functions this protocol provides. For example a client can do a broard search by asking the server for all his ads and add the referenced advertisementservers to a local list and continue asking. The ads can then be used for a search. Thus the locality principle can be used in order to search effectively.



     

