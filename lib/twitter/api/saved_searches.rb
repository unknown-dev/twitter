require 'twitter/api/utils'
require 'twitter/saved_search'

module Twitter
  module API
    module SavedSearches
      include Twitter::API::Utils

      # @rate_limited Yes
      # @authentication_required Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Array<Twitter::SavedSearch>] The saved searches.
      # @overload saved_search(options={})
      #   Returns the authenticated user's saved search queries
      #
      #   @see https://dev.twitter.com/docs/api/1.1/get/saved_searches/list
      #   @param options [Hash] A customizable set of options.
      #   @example Return the authenticated user's saved search queries
      #     Twitter.saved_searches
      # @overload saved_search(*ids)
      #   Retrieve the data for saved searches owned by the authenticating user
      #
      #   @see https://dev.twitter.com/docs/api/1.1/get/saved_searches/show/:id
      #   @param ids [Array<Integer>, Set<Integer>] An array of Tweet IDs.
      #   @example Retrieve the data for a saved search owned by the authenticating user with the ID 16129012
      #     Twitter.saved_search(16129012)
      # @overload saved_search(*ids, options)
      #   Retrieve the data for saved searches owned by the authenticating user
      #
      #   @see https://dev.twitter.com/docs/api/1.1/get/saved_searches/show/:id
      #   @param ids [Array<Integer>, Set<Integer>] An array of Tweet IDs.
      #   @param options [Hash] A customizable set of options.
      def saved_searches(*args)
        options = extract_options!(args)
        if args.empty?
          collection_from_response(Twitter::SavedSearch, :get, "/1.1/saved_searches/list.json", options)
        else
          args.flatten.pmap do |id|
            saved_search(id)
          end
        end
      end

      # Retrieve the data for saved searches owned by the authenticating user
      #
      # @see https://dev.twitter.com/docs/api/1.1/get/saved_searches/show/:id
      # @rate_limited Yes
      # @authentication_required Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Twitter::SavedSearch] The saved searches.
      # @param id [Integer] A Tweet IDs.
      # @param options [Hash] A customizable set of options.
      # @example Retrieve the data for a saved search owned by the authenticating user with the ID 16129012
      #   Twitter.saved_search(16129012)
      def saved_search(id, options={})
        object_from_response(Twitter::SavedSearch, :get, "/1.1/saved_searches/show/#{id}.json", options)
      end

      # Creates a saved search for the authenticated user
      #
      # @see https://dev.twitter.com/docs/api/1.1/post/saved_searches/create
      # @rate_limited No
      # @authentication_required Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Twitter::SavedSearch] The created saved search.
      # @param query [String] The query of the search the user would like to save.
      # @param options [Hash] A customizable set of options.
      # @example Create a saved search for the authenticated user with the query "twitter"
      #   Twitter.saved_search_create("twitter")
      def saved_search_create(query, options={})
        object_from_response(Twitter::SavedSearch, :post, "/1.1/saved_searches/create.json", options.merge(:query => query))
      end

      # Destroys saved searches for the authenticated user
      #
      # @see https://dev.twitter.com/docs/api/1.1/post/saved_searches/destroy/:id
      # @note The search specified by ID must be owned by the authenticating user.
      # @rate_limited No
      # @authentication_required Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Array<Twitter::SavedSearch>] The deleted saved searches.
      # @overload saved_search_destroy(*ids)
      #   @param ids [Array<Integer>, Set<Integer>] An array of Tweet IDs.
      #   @example Destroys a saved search for the authenticated user with the ID 16129012
      #     Twitter.saved_search_destroy(16129012)
      # @overload saved_search_destroy(*ids, options)
      #   @param ids [Array<Integer>, Set<Integer>] An array of Tweet IDs.
      #   @param options [Hash] A customizable set of options.
      def saved_search_destroy(*args)
        options = extract_options!(args)
        args.flatten.pmap do |id|
          object_from_response(Twitter::SavedSearch, :post, "/1.1/saved_searches/destroy/#{id}.json", options)
        end
      end

    end
  end
end
