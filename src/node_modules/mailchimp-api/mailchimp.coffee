
https = require 'https'

OPTS = {
    host:   'api.mailchimp.com',
    port:   443,
    prefix: '/2.0/',
    method: 'POST',
    headers: {'Content-Type': 'application/json', 'User-Agent': 'MailChimp-Node/2.0.7'}
}

class exports.Mailchimp
    constructor: (@apikey=null, @debug=false) ->
        @folders = new Folders(this)
        @templates = new Templates(this)
        @users = new Users(this)
        @helper = new Helper(this)
        @mobile = new Mobile(this)
        @conversations = new Conversations(this)
        @ecomm = new Ecomm(this)
        @neapolitan = new Neapolitan(this)
        @lists = new Lists(this)
        @campaigns = new Campaigns(this)
        @vip = new Vip(this)
        @reports = new Reports(this)
        @gallery = new Gallery(this)
        @goal = new Goal(this)

        if @apikey == null then @apikey = process.env['MAILCHIMP_APIKEY']

    call: (uri, params={}, onresult, onerror) ->
        params.apikey = @apikey;
        pieces = OPTS.host.split('.');
        if pieces.length == 3
            dc = 'us1';
            parts = params.apikey.split('-');
            if parts.length == 2
                dc = parts[1]
            OPTS.host = dc + '.' + OPTS.host;
        
        params = new Buffer(JSON.stringify(params), 'utf8')

        if @debug then console.log("Mailchimp: Opening request to https://#{OPTS.host}#{OPTS.prefix}#{uri}.json")
        OPTS.path = "#{OPTS.prefix}#{uri}.json"
        OPTS.headers['Content-Length'] = params.length
        req = https.request(OPTS, (res) =>
            res.setEncoding('utf8')
            json = ''
            res.on('data', (d) =>
                json += d
            )

            res.on('end', =>
                try
                    json = JSON.parse(json)
                catch e
                    json = {status: 'error', name: 'GeneralError', error: e}
                
                json ?= {status: 'error', name: 'GeneralError', error: 'An unexpected error occurred'}
                if res.statusCode != 200
                    if onerror then onerror(json) else @onerror(json)
                else
                    if onresult then onresult(json)
            )
        )
        req.write(params)
        req.end()
        req.on('error', (e) =>
            if onerror then onerror(e) else @onerror({status: 'error', name: 'GeneralError', error: e})
        )

        return null

    onerror: (err) ->
        throw {name: err.name, error: err.error, toString: -> "#{err.name}: #{err.error}"}
        
    parseArgs: (params, onsuccess, onerror) ->
        return [params, onsuccess, onerror] if typeof params isnt 'function'
        [params, onsuccess, onerror] = [{}, params, onsuccess]


class Folders
    constructor: (@master) ->


    ###
    Add a new folder to file campaigns, autoresponders, or templates in
    @param {Object} params the hash of the parameters to pass to the request
    @option params {String} name a unique name for a folder (max 100 bytes)
    @option params {String} type the type of folder to create - one of "campaign", "autoresponder", or "template".
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    add: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror


        @master.call('folders/add', params, onsuccess, onerror)

    ###
    Delete a campaign, autoresponder, or template folder. Note that this will simply make whatever was in the folder appear unfiled, no other data is removed
    @param {Object} params the hash of the parameters to pass to the request
    @option params {Int} fid the folder id to delete - retrieve from folders/list()
    @option params {String} type the type of folder to delete - either "campaign", "autoresponder", or "template"
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    del: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror


        @master.call('folders/del', params, onsuccess, onerror)

    ###
    List all the folders of a certain type
    @param {Object} params the hash of the parameters to pass to the request
    @option params {String} type the type of folders to return "campaign", "autoresponder", or "template"
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    list: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror


        @master.call('folders/list', params, onsuccess, onerror)

    ###
    Update the name of a folder for campaigns, autoresponders, or templates
    @param {Object} params the hash of the parameters to pass to the request
    @option params {Int} fid the folder id to update - retrieve from folders/list()
    @option params {String} name a new, unique name for the folder (max 100 bytes)
    @option params {String} type the type of folder to update - one of "campaign", "autoresponder", or "template".
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    update: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror


        @master.call('folders/update', params, onsuccess, onerror)
class Templates
    constructor: (@master) ->


    ###
    Create a new user template, <strong>NOT</strong> campaign content. These templates can then be applied while creating campaigns.
    @param {Object} params the hash of the parameters to pass to the request
    @option params {String} name the name for the template - names must be unique and a max of 50 bytes
    @option params {String} html a string specifying the entire template to be created. This is <strong>NOT</strong> campaign content. They are intended to utilize our <a href="http://www.mailchimp.com/resources/email-template-language/" target="_blank">template language</a>.
    @option params {Int} folder_id the folder to put this template in.
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    add: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror

        params["folder_id"] ?= null

        @master.call('templates/add', params, onsuccess, onerror)

    ###
    Delete (deactivate) a user template
    @param {Object} params the hash of the parameters to pass to the request
    @option params {Int} template_id the id of the user template to delete
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    del: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror


        @master.call('templates/del', params, onsuccess, onerror)

    ###
    Pull details for a specific template to help support editing
    @param {Object} params the hash of the parameters to pass to the request
    @option params {Int} template_id the template id - get from templates/list()
    @option params {String} type optional the template type to load - one of 'user', 'gallery', 'base', defaults to user.
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    info: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror

        params["type"] ?= 'user'

        @master.call('templates/info', params, onsuccess, onerror)

    ###
    Retrieve various templates available in the system, allowing some thing similar to our template gallery to be created.
    @param {Object} params the hash of the parameters to pass to the request
    @option params {Struct} types optional the types of templates to return
         - user {Boolean} Custom templates for this user account. Defaults to true.
         - gallery {Boolean} Templates from our Gallery. Note that some templates that require extra configuration are withheld. (eg, the Etsy template). Defaults to false.
         - base {Boolean} Our "start from scratch" extremely basic templates. Defaults to false. As of the 9.0 update, "base" templates are no longer available via the API because they are now all saved Drag & Drop templates.
    @option params {Struct} filters optional options to control how inactive templates are returned, if at all
         - category {String} optional for Gallery templates only, limit to a specific template category
         - folder_id {String} user templates, limit to this folder_id
         - include_inactive {Boolean} user templates are not deleted, only set inactive. defaults to false.
         - inactive_only {Boolean} only include inactive user templates. defaults to false.
         - include_drag_and_drop {Boolean} Include templates created and saved using the new Drag & Drop editor. <strong>Note:</strong> You will not be able to edit or create new drag & drop templates via this API. This is useful only for creating a new campaign based on a drag & drop template.
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    list: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror

        params["types"] ?= []
        params["filters"] ?= []

        @master.call('templates/list', params, onsuccess, onerror)

    ###
    Undelete (reactivate) a user template
    @param {Object} params the hash of the parameters to pass to the request
    @option params {Int} template_id the id of the user template to reactivate
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    undel: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror


        @master.call('templates/undel', params, onsuccess, onerror)

    ###
    Replace the content of a user template, <strong>NOT</strong> campaign content.
    @param {Object} params the hash of the parameters to pass to the request
    @option params {Int} template_id the id of the user template to update
    @option params {Struct} values the values to updates - while both are optional, at least one should be provided. Both can be updated at the same time.
         - name {String} the name for the template - names must be unique and a max of 50 bytes
         - html {String} a string specifying the entire template to be created. This is <strong>NOT</strong> campaign content. They are intended to utilize our <a href="http://www.mailchimp.com/resources/email-template-language/" target="_blank">template language</a>.
         - folder_id {Int} the folder to put this template in - 0 or a blank values will remove it from a folder.
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    update: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror


        @master.call('templates/update', params, onsuccess, onerror)
class Users
    constructor: (@master) ->


    ###
    Invite a user to your account
    @param {Object} params the hash of the parameters to pass to the request
    @option params {String} email A valid email address to send the invitation to
    @option params {String} role the role to assign to the user - one of viewer, author, manager, admin. defaults to viewer. More details <a href="http://kb.mailchimp.com/article/can-we-have-multiple-users-on-our-account-with-limited-access" target="_blank">here</a>
    @option params {String} msg an optional message to include. Plain text any HTML tags will be stripped.
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    invite: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror

        params["role"] ?= 'viewer'
        params["msg"] ?= ''

        @master.call('users/invite', params, onsuccess, onerror)

    ###
    Resend an invite a user to your account. Note, if the same address has been invited multiple times, this will simpy re-send the most recent invite
    @param {Object} params the hash of the parameters to pass to the request
    @option params {String} email A valid email address to resend an invitation to
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    inviteResend: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror


        @master.call('users/invite-resend', params, onsuccess, onerror)

    ###
    Revoke an invitation sent to a user to your account. Note, if the same address has been invited multiple times, this will simpy revoke the most recent invite
    @param {Object} params the hash of the parameters to pass to the request
    @option params {String} email A valid email address to send the invitation to
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    inviteRevoke: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror


        @master.call('users/invite-revoke', params, onsuccess, onerror)

    ###
    Retrieve the list of pending users invitations have been sent for.
    @param {Object} params the hash of the parameters to pass to the request
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    invites: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror


        @master.call('users/invites', params, onsuccess, onerror)

    ###
    Revoke access for a specified login
    @param {Object} params the hash of the parameters to pass to the request
    @option params {String} username The username of the login to revoke access of
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    loginRevoke: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror


        @master.call('users/login-revoke', params, onsuccess, onerror)

    ###
    Retrieve the list of active logins.
    @param {Object} params the hash of the parameters to pass to the request
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    logins: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror


        @master.call('users/logins', params, onsuccess, onerror)

    ###
    Retrieve the profile for the login owning the provided API Key
    @param {Object} params the hash of the parameters to pass to the request
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    profile: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror


        @master.call('users/profile', params, onsuccess, onerror)
class Helper
    constructor: (@master) ->


    ###
    Retrieve lots of account information including payments made, plan info, some account stats, installed modules,
contact info, and more. No private information like Credit Card numbers is available.
    @param {Object} params the hash of the parameters to pass to the request
    @option params {Array} exclude defaults to nothing for backwards compatibility. Allows controlling which extra arrays are returned since they can slow down calls. Valid keys are "modules", "orders", "rewards-credits", "rewards-inspections", "rewards-referrals", "rewards-applied", "integrations". Hint: "rewards-referrals" is typically the culprit. To avoid confusion, if data is excluded, the corresponding key <strong>will not be returned at all</strong>.
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    accountDetails: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror

        params["exclude"] ?= []

        @master.call('helper/account-details', params, onsuccess, onerror)

    ###
    Retrieve minimal data for all Campaigns a member was sent
    @param {Object} params the hash of the parameters to pass to the request
    @option params {Struct} email a struct with one fo the following keys - failing to provide anything will produce an error relating to the email address
         - email {String} an email address
         - euid {String} the unique id for an email address (not list related) - the email "id" returned from listMemberInfo, Webhooks, Campaigns, etc.
         - leid {String} the list email id (previously called web_id) for a list-member-info type call. this doesn't change when the email address changes
    @option params {Struct} options optional extra options to modify the returned data.
         - list_id {String} optional A list_id to limit the campaigns to
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    campaignsForEmail: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror

        params["options"] ?= null

        @master.call('helper/campaigns-for-email', params, onsuccess, onerror)

    ###
    Return the current Chimp Chatter messages for an account.
    @param {Object} params the hash of the parameters to pass to the request
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    chimpChatter: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror


        @master.call('helper/chimp-chatter', params, onsuccess, onerror)

    ###
    Have HTML content auto-converted to a text-only format. You can send: plain HTML, an existing Campaign Id, or an existing Template Id. Note that this will <strong>not</strong> save anything to or update any of your lists, campaigns, or templates.
It's also not just Lynx and is very fine tuned for our template layouts - your mileage may vary.
    @param {Object} params the hash of the parameters to pass to the request
    @option params {String} type The type of content to parse. Must be one of: "html", "url", "cid" (Campaign Id), "user_template_id", "base_template_id", "gallery_template_id"
    @option params {Struct} content The content to use. The key names should be the same as type and while listed as optional, may cause errors if the content is obviously required (ie, html)
         - html {String} optional a single string value,
         - cid {String} a valid Campaign Id
         - user_template_id {String} the id of a user template
         - base_template_id {String} the id of a built in base/basic template
         - gallery_template_id {String} the id of a built in gallery template
         - url {String} a valid & public URL to pull html content from
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    generateText: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror


        @master.call('helper/generate-text', params, onsuccess, onerror)

    ###
    Send your HTML content to have the CSS inlined and optionally remove the original styles.
    @param {Object} params the hash of the parameters to pass to the request
    @option params {String} html Your HTML content
    @option params {Bool} strip_css optional Whether you want the CSS &lt;style&gt; tags stripped from the returned document. Defaults to false.
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    inlineCss: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror

        params["strip_css"] ?= false

        @master.call('helper/inline-css', params, onsuccess, onerror)

    ###
    Retrieve minimal List data for all lists a member is subscribed to.
    @param {Object} params the hash of the parameters to pass to the request
    @option params {Struct} email a struct with one fo the following keys - failing to provide anything will produce an error relating to the email address
         - email {String} an email address
         - euid {String} the unique id for an email address (not list related) - the email "id" returned from listMemberInfo, Webhooks, Campaigns, etc.
         - leid {String} the list email id (previously called web_id) for a list-member-info type call. this doesn't change when the email address changes
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    listsForEmail: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror


        @master.call('helper/lists-for-email', params, onsuccess, onerror)

    ###
    "Ping" the MailChimp API - a simple method you can call that will return a constant value as long as everything is good. Note
than unlike most all of our methods, we don't throw an Exception if we are having issues. You will simply receive a different
string back that will explain our view on what is going on.
    @param {Object} params the hash of the parameters to pass to the request
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    ping: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror


        @master.call('helper/ping', params, onsuccess, onerror)

    ###
    Search all campaigns for the specified query terms
    @param {Object} params the hash of the parameters to pass to the request
    @option params {String} query terms to search on
    @option params {Int} offset optional the paging offset to use if more than 100 records match
    @option params {String} snip_start optional by default clear text is returned. To have the match highlighted with something (like a strong HTML tag), <strong>both</strong> this and "snip_end" must be passed. You're on your own to not break the tags - 25 character max.
    @option params {String} snip_end optional see "snip_start" above.
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    searchCampaigns: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror

        params["offset"] ?= 0
        params["snip_start"] ?= null
        params["snip_end"] ?= null

        @master.call('helper/search-campaigns', params, onsuccess, onerror)

    ###
    Search account wide or on a specific list using the specified query terms
    @param {Object} params the hash of the parameters to pass to the request
    @option params {String} query terms to search on, <a href="http://kb.mailchimp.com/article/i-cant-find-a-recipient-on-my-list" target="_blank">just like you do in the app</a>
    @option params {String} id optional the list id to limit the search to. Get by calling lists/list()
    @option params {Int} offset optional the paging offset to use if more than 100 records match
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    searchMembers: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror

        params["id"] ?= null
        params["offset"] ?= 0

        @master.call('helper/search-members', params, onsuccess, onerror)

    ###
    Retrieve all domain verification records for an account
    @param {Object} params the hash of the parameters to pass to the request
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    verifiedDomains: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror


        @master.call('helper/verified-domains', params, onsuccess, onerror)
class Mobile
    constructor: (@master) ->

class Conversations
    constructor: (@master) ->


    ###
    Retrieve conversation metadata, includes message data for the most recent message in the conversation
    @param {Object} params the hash of the parameters to pass to the request
    @option params {String} list_id optional the list id to connect to. Get by calling lists/list()
    @option params {String} leid optional The member's 'leid', as found by calling lists/member-info()
    @option params {String} campaign_id the campaign id to get content for (can be gathered using campaigns/list())
    @option params {Int} start optional - control paging, start results at this offset, defaults to 0 (1st page of data)
    @option params {Int} limit optional - control paging, number of results to return with each call, defaults to 25 (max=100)
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    list: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror

        params["list_id"] ?= null
        params["leid"] ?= null
        params["campaign_id"] ?= null
        params["start"] ?= 0
        params["limit"] ?= 25

        @master.call('conversations/list', params, onsuccess, onerror)

    ###
    Retrieve conversation messages
    @param {Object} params the hash of the parameters to pass to the request
    @option params {String} conversation_id the unique_id of the conversation to retrieve the messages for, can be obtained by calling converstaions/list().
    @option params {Boolean} mark_as_read optional Whether or not the conversation ought to be marked as read (defaults to false).
    @option params {Int} start optional - control paging, start results at this offset, defaults to 1st page of data (offset 0)
    @option params {Int} limit optional - control paging, number of results to return with each call, defaults to 25 (max=100)
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    messages: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror

        params["mark_as_read"] ?= false
        params["start"] ?= 0
        params["limit"] ?= 25

        @master.call('conversations/messages', params, onsuccess, onerror)

    ###
    Reply to a conversation
    @param {Object} params the hash of the parameters to pass to the request
    @option params {String} conversation_id the unique_id of the conversation to retrieve the messages for, can be obtained by calling converstaions/list().
    @option params {String} message the text of the message you want to send.
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    reply: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror


        @master.call('conversations/reply', params, onsuccess, onerror)
class Ecomm
    constructor: (@master) ->


    ###
    Import Ecommerce Order Information to be used for Segmentation. This will generally be used by ecommerce package plugins
<a href="http://connect.mailchimp.com/category/ecommerce" target="_blank">provided by us or by 3rd part system developers</a>.
    @param {Object} params the hash of the parameters to pass to the request
    @option params {Struct} order information pertaining to the order that has completed. Use the following keys:
         - id {String} the Order Id
         - campaign_id {String} optional the Campaign Id to track this order against (see the "mc_cid" query string variable a campaign passes)
         - email_id {String} optional (kind of) the Email Id of the subscriber we should attach this order to (see the "mc_eid" query string variable a campaign passes) - required if campaign_id is passed, otherwise either this or <strong>email</strong> is required. If both are provided, email_id takes precedence
         - email {String} optional (kind of) the Email Address we should attach this order to - either this or <strong>email_id</strong> is required. If both are provided, email_id takes precedence
         - total {Double} The Order Total (ie, the full amount the customer ends up paying)
         - order_date {String} optional the date of the order - if this is not provided, we will default the date to now. Should be in the format of 2012-12-30
         - shipping {Double} optional the total paid for Shipping Fees
         - tax {Double} optional the total tax paid
         - store_id {String} a unique id for the store sending the order in (32 bytes max)
         - store_name {String} optional a "nice" name for the store - typically the base web address (ie, "store.mailchimp.com"). We will automatically update this if it changes (based on store_id)
         - items {Array} structs for each individual line item including:
             - line_num {Int} optional the line number of the item on the order. We will generate these if they are not passed
             - product_id {Int} the store's internal Id for the product. Lines that do no contain this will be skipped
             - sku {String} optional the store's internal SKU for the product. (max 30 bytes)
             - product_name {String} the product name for the product_id associated with this item. We will auto update these as they change (based on product_id) (max 500 bytes)
             - category_id {Int} (required) the store's internal Id for the (main) category associated with this product. Our testing has found this to be a "best guess" scenario
             - category_name {String} (required) the category name for the category_id this product is in. Our testing has found this to be a "best guess" scenario. Our plugins walk the category heirarchy up and send "Root - SubCat1 - SubCat4", etc.
             - qty {Double} optional the quantity of the item ordered - defaults to 1
             - cost {Double} optional the cost of a single item (ie, not the extended cost of the line) - defaults to 0
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    orderAdd: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror


        @master.call('ecomm/order-add', params, onsuccess, onerror)

    ###
    Delete Ecommerce Order Information used for segmentation. This will generally be used by ecommerce package plugins
<a href="/plugins/ecomm360.phtml">that we provide</a> or by 3rd part system developers.
    @param {Object} params the hash of the parameters to pass to the request
    @option params {String} store_id the store id the order belongs to
    @option params {String} order_id the order id (generated by the store) to delete
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    orderDel: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror


        @master.call('ecomm/order-del', params, onsuccess, onerror)

    ###
    Retrieve the Ecommerce Orders for an account
    @param {Object} params the hash of the parameters to pass to the request
    @option params {String} cid if set, limit the returned orders to a particular campaign
    @option params {Int} start optional for large data sets, the page number to start at - defaults to 1st page of data  (page 0)
    @option params {Int} limit optional for large data sets, the number of results to return - defaults to 100, upper limit set at 500
    @option params {String} since optional pull only messages since this time - 24 hour format in <strong>GMT</strong>, eg "2013-12-30 20:30:00"
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    orders: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror

        params["cid"] ?= null
        params["start"] ?= 0
        params["limit"] ?= 100
        params["since"] ?= null

        @master.call('ecomm/orders', params, onsuccess, onerror)
class Neapolitan
    constructor: (@master) ->

class Lists
    constructor: (@master) ->


    ###
    Get all email addresses that complained about a campaign sent to a list
    @param {Object} params the hash of the parameters to pass to the request
    @option params {String} id the list id to pull abuse reports for (can be gathered using lists/list())
    @option params {Int} start optional for large data sets, the page number to start at - defaults to 1st page of data  (page 0)
    @option params {Int} limit optional for large data sets, the number of results to return - defaults to 500, upper limit set at 1000
    @option params {String} since optional pull only messages since this time - 24 hour format in <strong>GMT</strong>, eg "2013-12-30 20:30:00"
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    abuseReports: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror

        params["start"] ?= 0
        params["limit"] ?= 500
        params["since"] ?= null

        @master.call('lists/abuse-reports', params, onsuccess, onerror)

    ###
    Access up to the previous 180 days of daily detailed aggregated activity stats for a given list. Does not include AutoResponder activity.
    @param {Object} params the hash of the parameters to pass to the request
    @option params {String} id the list id to connect to. Get by calling lists/list()
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    activity: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror


        @master.call('lists/activity', params, onsuccess, onerror)

    ###
    Subscribe a batch of email addresses to a list at once. If you are using a serialized version of the API, we strongly suggest that you
only run this method as a POST request, and <em>not</em> a GET request. Maximum batch sizes vary based on the amount of data in each record,
though you should cap them at 5k - 10k records, depending on your experience. These calls are also long, so be sure you increase your timeout values.
    @param {Object} params the hash of the parameters to pass to the request
    @option params {String} id the list id to connect to. Get by calling lists/list()
    @option params {Array} batch an array of structs for each address using the following keys:
         - email {Object} a struct with one of the following keys - failing to provide anything will produce an error relating to the email address. Provide multiples and we'll use the first we see in this same order.
             - email {String} an email address
             - euid {String} the unique id for an email address (not list related) - the email "id" returned from listMemberInfo, Webhooks, Campaigns, etc.
             - leid {String} the list email id (previously called web_id) for a list-member-info type call. this doesn't change when the email address changes
         - email_type {String} for the email type option (html or text)
         - merge_vars {Object} data for the various list specific and special merge vars documented in lists/subscribe
    @option params {Boolean} double_optin flag to control whether to send an opt-in confirmation email - defaults to true
    @option params {Boolean} update_existing flag to control whether to update members that are already subscribed to the list or to return an error, defaults to false (return error)
    @option params {Boolean} replace_interests flag to determine whether we replace the interest groups with the updated groups provided, or we add the provided groups to the member's interest groups (optional, defaults to true)
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    batchSubscribe: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror

        params["double_optin"] ?= true
        params["update_existing"] ?= false
        params["replace_interests"] ?= true

        @master.call('lists/batch-subscribe', params, onsuccess, onerror)

    ###
    Unsubscribe a batch of email addresses from a list
    @param {Object} params the hash of the parameters to pass to the request
    @option params {String} id the list id to connect to. Get by calling lists/list()
    @option params {Array} batch array of structs to unsubscribe, each with one of the following keys - failing to provide anything will produce an error relating to the email address. Provide multiples and we'll use the first we see in this same order.
         - email {String} an email address
         - euid {String} the unique id for an email address (not list related) - the email "id" returned from listMemberInfo, Webhooks, Campaigns, etc.
         - leid {String} the list email id (previously called web_id) for a list-member-info type call. this doesn't change when the email address changes
    @option params {Boolean} delete_member flag to completely delete the member from your list instead of just unsubscribing, default to false
    @option params {Boolean} send_goodbye flag to send the goodbye email to the email addresses, defaults to true
    @option params {Boolean} send_notify flag to send the unsubscribe notification email to the address defined in the list email notification settings, defaults to false
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    batchUnsubscribe: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror

        params["delete_member"] ?= false
        params["send_goodbye"] ?= true
        params["send_notify"] ?= false

        @master.call('lists/batch-unsubscribe', params, onsuccess, onerror)

    ###
    Retrieve the clients that the list's subscribers have been tagged as being used based on user agents seen. Made possible by <a href="http://user-agent-string.info" target="_blank">user-agent-string.info</a>
    @param {Object} params the hash of the parameters to pass to the request
    @option params {String} id the list id to connect to. Get by calling lists/list()
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    clients: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror


        @master.call('lists/clients', params, onsuccess, onerror)

    ###
    Access the Growth History by Month in aggregate or for a given list.
    @param {Object} params the hash of the parameters to pass to the request
    @option params {String} id optional - if provided, the list id to connect to. Get by calling lists/list(). Otherwise the aggregate for the account.
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    growthHistory: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror

        params["id"] ?= null

        @master.call('lists/growth-history', params, onsuccess, onerror)

    ###
    Get the list of interest groupings for a given list, including the label, form information, and included groups for each
    @param {Object} params the hash of the parameters to pass to the request
    @option params {String} id the list id to connect to. Get by calling lists/list()
    @option params {Bool} counts optional whether or not to return subscriber counts for each group. defaults to false since that slows this call down a ton for large lists.
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    interestGroupings: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror

        params["counts"] ?= false

        @master.call('lists/interest-groupings', params, onsuccess, onerror)

    ###
    Add a single Interest Group - if interest groups for the List are not yet enabled, adding the first
group will automatically turn them on.
    @param {Object} params the hash of the parameters to pass to the request
    @option params {String} id the list id to connect to. Get by calling lists/list()
    @option params {String} group_name the interest group to add - group names must be unique within a grouping
    @option params {Int} grouping_id optional The grouping to add the new group to - get using lists/interest-groupings() . If not supplied, the first grouping on the list is used.
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    interestGroupAdd: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror

        params["grouping_id"] ?= null

        @master.call('lists/interest-group-add', params, onsuccess, onerror)

    ###
    Delete a single Interest Group - if the last group for a list is deleted, this will also turn groups for the list off.
    @param {Object} params the hash of the parameters to pass to the request
    @option params {String} id the list id to connect to. Get by calling lists/list()
    @option params {String} group_name the interest group to delete
    @option params {Int} grouping_id The grouping to delete the group from - get using lists/interest-groupings() . If not supplied, the first grouping on the list is used.
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    interestGroupDel: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror

        params["grouping_id"] ?= null

        @master.call('lists/interest-group-del', params, onsuccess, onerror)

    ###
    Change the name of an Interest Group
    @param {Object} params the hash of the parameters to pass to the request
    @option params {String} id the list id to connect to. Get by calling lists/list()
    @option params {String} old_name the interest group name to be changed
    @option params {String} new_name the new interest group name to be set
    @option params {Int} grouping_id optional The grouping to delete the group from - get using lists/interest-groupings() . If not supplied, the first grouping on the list is used.
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    interestGroupUpdate: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror

        params["grouping_id"] ?= null

        @master.call('lists/interest-group-update', params, onsuccess, onerror)

    ###
    Add a new Interest Grouping - if interest groups for the List are not yet enabled, adding the first
grouping will automatically turn them on.
    @param {Object} params the hash of the parameters to pass to the request
    @option params {String} id the list id to connect to. Get by calling lists/list()
    @option params {String} name the interest grouping to add - grouping names must be unique
    @option params {String} type The type of the grouping to add - one of "checkboxes", "hidden", "dropdown", "radio"
    @option params {Array} groups The lists of initial group names to be added - at least 1 is required and the names must be unique within a grouping. If the number takes you over the 60 group limit, an error will be thrown.
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    interestGroupingAdd: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror


        @master.call('lists/interest-grouping-add', params, onsuccess, onerror)

    ###
    Delete an existing Interest Grouping - this will permanently delete all contained interest groups and will remove those selections from all list members
    @param {Object} params the hash of the parameters to pass to the request
    @option params {Int} grouping_id the interest grouping id - get from lists/interest-groupings()
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    interestGroupingDel: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror


        @master.call('lists/interest-grouping-del', params, onsuccess, onerror)

    ###
    Update an existing Interest Grouping
    @param {Object} params the hash of the parameters to pass to the request
    @option params {Int} grouping_id the interest grouping id - get from lists/interest-groupings()
    @option params {String} name The name of the field to update - either "name" or "type". Groups within the grouping should be manipulated using the standard listInterestGroup* methods
    @option params {String} value The new value of the field. Grouping names must be unique - only "hidden" and "checkboxes" grouping types can be converted between each other.
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    interestGroupingUpdate: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror


        @master.call('lists/interest-grouping-update', params, onsuccess, onerror)

    ###
    Retrieve the locations (countries) that the list's subscribers have been tagged to based on geocoding their IP address
    @param {Object} params the hash of the parameters to pass to the request
    @option params {String} id the list id to connect to. Get by calling lists/list()
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    locations: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror


        @master.call('lists/locations', params, onsuccess, onerror)

    ###
    Get the most recent 100 activities for particular list members (open, click, bounce, unsub, abuse, sent to, etc.)
    @param {Object} params the hash of the parameters to pass to the request
    @option params {String} id the list id to connect to. Get by calling lists/list()
    @option params {Array} emails an array of up to 50 email structs, each with with one of the following keys
         - email {String} an email address - for new subscribers obviously this should be used
         - euid {String} the unique id for an email address (not list related) - the email "id" returned from listMemberInfo, Webhooks, Campaigns, etc.
         - leid {String} the list email id (previously called web_id) for a list-member-info type call. this doesn't change when the email address changes
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    memberActivity: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror


        @master.call('lists/member-activity', params, onsuccess, onerror)

    ###
    Get all the information for particular members of a list
    @param {Object} params the hash of the parameters to pass to the request
    @option params {String} id the list id to connect to. Get by calling lists/list()
    @option params {Array} emails an array of up to 50 email structs, each with with one of the following keys
         - email {String} an email address - for new subscribers obviously this should be used
         - euid {String} the unique id for an email address (not list related) - the email "id" returned from listMemberInfo, Webhooks, Campaigns, etc.
         - leid {String} the list email id (previously called web_id) for a list-member-info type call. this doesn't change when the email address changes
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    memberInfo: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror


        @master.call('lists/member-info', params, onsuccess, onerror)

    ###
    Get all of the list members for a list that are of a particular status and potentially matching a segment. This will cause locking, so don't run multiples at once. Are you trying to get a dump including lots of merge
data or specific members of a list? If so, checkout the <a href="/export/1.0/list.func.php">List Export API</a>
    @param {Object} params the hash of the parameters to pass to the request
    @option params {String} id the list id to connect to. Get by calling lists/list()
    @option params {String} status the status to get members for - one of(subscribed, unsubscribed, <a target="_blank" href="http://eepurl.com/gWOO">cleaned</a>), defaults to subscribed
    @option params {Struct} opts various options for controlling returned data
         - start {Int} optional for large data sets, the page number to start at - defaults to 1st page of data  (page 0)
         - limit {Int} optional for large data sets, the number of results to return - defaults to 25, upper limit set at 100
         - sort_field {String} optional the data field to sort by - mergeX (1-30), your custom merge tags, "email", "rating","last_update_time", or "optin_time" - invalid fields will be ignored
         - sort_dir {String} optional the direct - ASC or DESC. defaults to ASC (case insensitive)
         - segment {Object} a properly formatted segment that works with campaigns/segment-test
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    members: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror

        params["status"] ?= 'subscribed'
        params["opts"] ?= []

        @master.call('lists/members', params, onsuccess, onerror)

    ###
    Add a new merge tag to a given list
    @param {Object} params the hash of the parameters to pass to the request
    @option params {String} id the list id to connect to. Get by calling lists/list()
    @option params {String} tag The merge tag to add, e.g. FNAME. 10 bytes max, valid characters: "A-Z 0-9 _" no spaces, dashes, etc. Some tags and prefixes are <a href="http://kb.mailchimp.com/article/i-got-a-message-saying-that-my-list-field-name-is-reserved-and-cant-be-used" target="_blank">reserved</a>
    @option params {String} name The long description of the tag being added, used for user displays - max 50 bytes
    @option params {Struct} options optional Various options for this merge var
         - field_type {String} optional one of: text, number, radio, dropdown, date, address, phone, url, imageurl, zip, birthday - defaults to text
         - req {Boolean} optional indicates whether the field is required - defaults to false
         - public {Boolean} optional indicates whether the field is displayed in public - defaults to true
         - show {Boolean} optional indicates whether the field is displayed in the app's list member view - defaults to true
         - order {Int} The order this merge tag should be displayed in - this will cause existing values to be reset so this fits
         - default_value {String} optional the default value for the field. See lists/subscribe() for formatting info. Defaults to blank - max 255 bytes
         - helptext {String} optional the help text to be used with some newer forms. Defaults to blank - max 255 bytes
         - choices {Array} optional kind of - an array of strings to use as the choices for radio and dropdown type fields
         - dateformat {String} optional only valid for birthday and date fields. For birthday type, must be "MM/DD" (default) or "DD/MM". For date type, must be "MM/DD/YYYY" (default) or "DD/MM/YYYY". Any other values will be converted to the default.
         - phoneformat {String} optional "US" is the default - any other value will cause them to be unformatted (international)
         - defaultcountry {String} optional the <a href="http://www.iso.org/iso/english_country_names_and_code_elements" target="_blank">ISO 3166 2 digit character code</a> for the default country. Defaults to "US". Anything unrecognized will be converted to the default.
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    mergeVarAdd: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror

        params["options"] ?= []

        @master.call('lists/merge-var-add', params, onsuccess, onerror)

    ###
    Delete a merge tag from a given list and all its members. Seriously - the data is removed from all members as well!
Note that on large lists this method may seem a bit slower than calls you typically make.
    @param {Object} params the hash of the parameters to pass to the request
    @option params {String} id the list id to connect to. Get by calling lists/list()
    @option params {String} tag The merge tag to delete
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    mergeVarDel: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror


        @master.call('lists/merge-var-del', params, onsuccess, onerror)

    ###
    Completely resets all data stored in a merge var on a list. All data is removed and this action can not be undone.
    @param {Object} params the hash of the parameters to pass to the request
    @option params {String} id the list id to connect to. Get by calling lists/list()
    @option params {String} tag The merge tag to reset
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    mergeVarReset: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror


        @master.call('lists/merge-var-reset', params, onsuccess, onerror)

    ###
    Sets a particular merge var to the specified value for every list member. Only merge var ids 1 - 30 may be modified this way. This is generally a dirty method
unless you're fixing data since you should probably be using default_values and/or conditional content. as with lists/merge-var-reset(), this can not be undone.
    @param {Object} params the hash of the parameters to pass to the request
    @option params {String} id the list id to connect to. Get by calling lists/list()
    @option params {String} tag The merge tag to reset
    @option params {String} value The value to set - see lists/subscribe() for formatting. Must validate to something non-empty.
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    mergeVarSet: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror


        @master.call('lists/merge-var-set', params, onsuccess, onerror)

    ###
    Update most parameters for a merge tag on a given list. You cannot currently change the merge type
    @param {Object} params the hash of the parameters to pass to the request
    @option params {String} id the list id to connect to. Get by calling lists/list()
    @option params {String} tag The merge tag to update
    @option params {Struct} options The options to change for a merge var. See lists/merge-var-add() for valid options. "tag" and "name" may also be used here.
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    mergeVarUpdate: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror


        @master.call('lists/merge-var-update', params, onsuccess, onerror)

    ###
    Get the list of merge tags for a given list, including their name, tag, and required setting
    @param {Object} params the hash of the parameters to pass to the request
    @option params {Array} id the list ids to retrieve merge vars for. Get by calling lists/list() - max of 100
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    mergeVars: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror


        @master.call('lists/merge-vars', params, onsuccess, onerror)

    ###
    Retrieve all of Segments for a list.
    @param {Object} params the hash of the parameters to pass to the request
    @option params {String} id the list id to connect to. Get by calling lists/list()
    @option params {String} type optional, if specified should be "static" or "saved" and will limit the returned entries to that type
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    segments: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror

        params["type"] ?= null

        @master.call('lists/segments', params, onsuccess, onerror)

    ###
    Save a segment against a list for later use. There is no limit to the number of segments which can be saved. Static Segments <strong>are not</strong> tied
to any merge data, interest groups, etc. They essentially allow you to configure an unlimited number of custom segments which will have standard performance.
When using proper segments, Static Segments are one of the available options for segmentation just as if you used a merge var (and they can be used with other segmentation
options), though performance may degrade at that point. Saved Segments (called "auto-updating" in the app) are essentially just the match+conditions typically
used.
    @param {Object} params the hash of the parameters to pass to the request
    @option params {String} id the list id to connect to. Get by calling lists/list()
    @option params {Struct} opts various options for the new segment
         - type {String} either "static" or "saved"
         - name {String} a unique name per list for the segment - 100 byte maximum length, anything longer will throw an error
         - segment_opts {Object} for "saved" only, the standard segment match+conditions, just like campaigns/segment-test
             - match {String} "any" or "all"
             - conditions {Array} structs for each condition, just like campaigns/segment-test
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    segmentAdd: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror


        @master.call('lists/segment-add', params, onsuccess, onerror)

    ###
    Delete a segment. Note that this will, of course, remove any member affiliations with any static segments deleted
    @param {Object} params the hash of the parameters to pass to the request
    @option params {String} id the list id to connect to. Get by calling lists/list()
    @option params {Int} seg_id the id of the static segment to delete - get from lists/static-segments()
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    segmentDel: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror


        @master.call('lists/segment-del', params, onsuccess, onerror)

    ###
    Allows one to test their segmentation rules before creating a campaign using them - this is no different from campaigns/segment-test() and will eventually replace it.
For the time being, the crazy segmenting condition documentation will continue to live over there.
    @param {Object} params the hash of the parameters to pass to the request
    @option params {String} list_id the list to test segmentation on - get lists using lists/list()
    @option params {Struct} options See the campaigns/segment-test() call for details.
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    segmentTest: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror


        @master.call('lists/segment-test', params, onsuccess, onerror)

    ###
    Update an existing segment. The list and type can not be changed.
    @param {Object} params the hash of the parameters to pass to the request
    @option params {String} id the list id to connect to. Get by calling lists/list()
    @option params {Int} seg_id the segment to updated. Get by calling lists/segments()
    @option params {Struct} opts various options to update
         - name {String} a unique name per list for the segment - 100 byte maximum length, anything longer will throw an error
         - segment_opts {Object} for "saved" only, the standard segment match+conditions, just like campaigns/segment-test
             - match {String} "any" or "all"
             - conditions {Array} structs for each condition, just like campaigns/segment-test
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    segmentUpdate: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror


        @master.call('lists/segment-update', params, onsuccess, onerror)

    ###
    Save a segment against a list for later use. There is no limit to the number of segments which can be saved. Static Segments <strong>are not</strong> tied
to any merge data, interest groups, etc. They essentially allow you to configure an unlimited number of custom segments which will have standard performance.
When using proper segments, Static Segments are one of the available options for segmentation just as if you used a merge var (and they can be used with other segmentation
options), though performance may degrade at that point.
    @param {Object} params the hash of the parameters to pass to the request
    @option params {String} id the list id to connect to. Get by calling lists/list()
    @option params {String} name a unique name per list for the segment - 100 byte maximum length, anything longer will throw an error
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    staticSegmentAdd: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror


        @master.call('lists/static-segment-add', params, onsuccess, onerror)

    ###
    Delete a static segment. Note that this will, of course, remove any member affiliations with the segment
    @param {Object} params the hash of the parameters to pass to the request
    @option params {String} id the list id to connect to. Get by calling lists/list()
    @option params {Int} seg_id the id of the static segment to delete - get from lists/static-segments()
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    staticSegmentDel: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror


        @master.call('lists/static-segment-del', params, onsuccess, onerror)

    ###
    Add list members to a static segment. It is suggested that you limit batch size to no more than 10,000 addresses per call. Email addresses must exist on the list
in order to be included - this <strong>will not</strong> subscribe them to the list!
    @param {Object} params the hash of the parameters to pass to the request
    @option params {String} id the list id to connect to. Get by calling lists/list()
    @option params {Int} seg_id the id of the static segment to modify - get from lists/static-segments()
    @option params {Array} batch an array of email structs, each with with one of the following keys:
         - email {String} an email address
         - euid {String} the unique id for an email address (not list related) - the email "id" returned from lists/member-info(), Webhooks, Campaigns, etc.
         - leid {String} the list email id (previously called web_id) for a list-member-info type call. this doesn't change when the email address changes
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    staticSegmentMembersAdd: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror


        @master.call('lists/static-segment-members-add', params, onsuccess, onerror)

    ###
    Remove list members from a static segment. It is suggested that you limit batch size to no more than 10,000 addresses per call. Email addresses must exist on the list
in order to be removed - this <strong>will not</strong> unsubscribe them from the list!
    @param {Object} params the hash of the parameters to pass to the request
    @option params {String} id the list id to connect to. Get by calling lists/list()
    @option params {Int} seg_id the id of the static segment to delete - get from lists/static-segments()
    @option params {Array} batch an array of structs for each address using one of the following keys:
         - email {String} an email address
         - euid {String} the unique id for an email address (not list related) - the email "id" returned from listMemberInfo, Webhooks, Campaigns, etc.
         - leid {String} the list email id (previously called web_id) for a list-member-info type call. this doesn't change when the email address changes
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    staticSegmentMembersDel: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror


        @master.call('lists/static-segment-members-del', params, onsuccess, onerror)

    ###
    Resets a static segment - removes <strong>all</strong> members from the static segment. Note: does not actually affect list member data
    @param {Object} params the hash of the parameters to pass to the request
    @option params {String} id the list id to connect to. Get by calling lists/list()
    @option params {Int} seg_id the id of the static segment to reset  - get from lists/static-segments()
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    staticSegmentReset: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror


        @master.call('lists/static-segment-reset', params, onsuccess, onerror)

    ###
    Retrieve all of the Static Segments for a list.
    @param {Object} params the hash of the parameters to pass to the request
    @option params {String} id the list id to connect to. Get by calling lists/list()
    @option params {Boolean} get_counts optional Retreiving counts for static segments can be slow, leaving them out can speed up this call. Defaults to 'true'.
    @option params {Int} start optional - control paging, start results at this offset, defaults to 1st page of data (offset 0)
    @option params {Int} limit optional - control paging, number of results to return with each call, returns all by default
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    staticSegments: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror

        params["get_counts"] ?= true
        params["start"] ?= 0
        params["limit"] ?= null

        @master.call('lists/static-segments', params, onsuccess, onerror)

    ###
    Subscribe the provided email to a list. By default this sends a confirmation email - you will not see new members until the link contained in it is clicked!
    @param {Object} params the hash of the parameters to pass to the request
    @option params {String} id the list id to connect to. Get by calling lists/list()
    @option params {Struct} email a struct with one of the following keys - failing to provide anything will produce an error relating to the email address. If multiple keys are provided, the first one from the following list that we find will be used, the rest will be ignored.
         - email {String} an email address - for new subscribers obviously this should be used
         - euid {String} the unique id for an email address (not list related) - the email "id" returned from listMemberInfo, Webhooks, Campaigns, etc.
         - leid {String} the list email id (previously called web_id) for a list-member-info type call. this doesn't change when the email address changes
    @option params {Struct} merge_vars optional merges for the email (FNAME, LNAME, <a href="http://kb.mailchimp.com/article/where-can-i-find-my-lists-merge-tags" target="_blank">etc.</a>) (see examples below for handling "blank" arrays). Note that a merge field can only hold up to 255 bytes. Also, there are a few "special" keys:
         - new-email {String} set this to change the email address. This is only respected on calls using update_existing or when passed to lists/update.
         - groupings {Array} of Interest Grouping structs. Each should contain:
             - id {Int} Grouping "id" from lists/interest-groupings (either this or name must be present) - this id takes precedence and can't change (unlike the name)
             - name {String} Grouping "name" from lists/interest-groupings (either this or id must be present)
             - groups {Array} an array of valid group names for this grouping.
         - optin_ip {String} Set the Opt-in IP field. <em>Abusing this may cause your account to be suspended.</em> We do validate this and it must not be a private IP address.
         - optin_time {String} Set the Opt-in Time field. <em>Abusing this may cause your account to be suspended.</em> We do validate this and it must be a valid date. Use  - 24 hour format in <strong>GMT</strong>, eg "2013-12-30 20:30:00" to be safe. Generally, though, anything strtotime() understands we'll understand - <a href="http://us2.php.net/strtotime" target="_blank">http://us2.php.net/strtotime</a>
         - mc_location {Object} Set the member's geographic location either by optin_ip or geo data.
             - latitude {String} use the specified latitude (longitude must exist for this to work)
             - longitude {String} use the specified longitude (latitude must exist for this to work)
             - anything {String} if this (or any other key exists here) we'll try to use the optin ip. NOTE - this will slow down each subscribe call a bit, especially for lat/lng pairs in sparsely populated areas. Currently our automated background processes can and will overwrite this based on opens and clicks.
         - mc_language {String} Set the member's language preference. Supported codes are fully case-sensitive and can be found <a href="http://kb.mailchimp.com/article/can-i-see-what-languages-my-subscribers-use#code" target="_new">here</a>.
         - mc_notes {Array} of structs for managing notes - it may contain:
             - note {String} the note to set. this is required unless you're deleting a note
             - id {Int} the note id to operate on. not including this (or using an invalid id) causes a new note to be added
             - action {String} if the "id" key exists and is valid, an "update" key may be set to "append" (default), "prepend", "replace", or "delete" to handle how we should update existing notes. "delete", obviously, will only work with a valid "id" - passing that along with "note" and an invalid "id" is wrong and will be ignored.
    @option params {String} email_type optional email type preference for the email (html or text - defaults to html)
    @option params {Bool} double_optin optional flag to control whether a double opt-in confirmation message is sent, defaults to true. <em>Abusing this may cause your account to be suspended.</em>
    @option params {Bool} update_existing optional flag to control whether existing subscribers should be updated instead of throwing an error, defaults to false
    @option params {Bool} replace_interests optional flag to determine whether we replace the interest groups with the groups provided or we add the provided groups to the member's interest groups (optional, defaults to true)
    @option params {Bool} send_welcome optional if your double_optin is false and this is true, we will send your lists Welcome Email if this subscribe succeeds - this will *not* fire if we end up updating an existing subscriber. If double_optin is true, this has no effect. defaults to false.
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    subscribe: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror

        params["merge_vars"] ?= null
        params["email_type"] ?= 'html'
        params["double_optin"] ?= true
        params["update_existing"] ?= false
        params["replace_interests"] ?= true
        params["send_welcome"] ?= false

        @master.call('lists/subscribe', params, onsuccess, onerror)

    ###
    Unsubscribe the given email address from the list
    @param {Object} params the hash of the parameters to pass to the request
    @option params {String} id the list id to connect to. Get by calling lists/list()
    @option params {Struct} email a struct with one of the following keys - failing to provide anything will produce an error relating to the email address. If multiple keys are provided, the first one from the following list that we find will be used, the rest will be ignored.
         - email {String} an email address
         - euid {String} the unique id for an email address (not list related) - the email "id" returned from listMemberInfo, Webhooks, Campaigns, etc.
         - leid {String} the list email id (previously called web_id) for a list-member-info type call. this doesn't change when the email address changes
    @option params {Boolean} delete_member flag to completely delete the member from your list instead of just unsubscribing, default to false
    @option params {Boolean} send_goodbye flag to send the goodbye email to the email address, defaults to true
    @option params {Boolean} send_notify flag to send the unsubscribe notification email to the address defined in the list email notification settings, defaults to true
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    unsubscribe: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror

        params["delete_member"] ?= false
        params["send_goodbye"] ?= true
        params["send_notify"] ?= true

        @master.call('lists/unsubscribe', params, onsuccess, onerror)

    ###
    Edit the email address, merge fields, and interest groups for a list member. If you are doing a batch update on lots of users,
consider using lists/batch-subscribe() with the update_existing and possible replace_interests parameter.
    @param {Object} params the hash of the parameters to pass to the request
    @option params {String} id the list id to connect to. Get by calling lists/list()
    @option params {Struct} email a struct with one of the following keys - failing to provide anything will produce an error relating to the email address. If multiple keys are provided, the first one from the following list that we find will be used, the rest will be ignored.
         - email {String} an email address
         - euid {String} the unique id for an email address (not list related) - the email "id" returned from listMemberInfo, Webhooks, Campaigns, etc.
         - leid {String} the list email id (previously called web_id) for a list-member-info type call. this doesn't change when the email address changes
    @option params {Struct} merge_vars new field values to update the member with.  See merge_vars in lists/subscribe() for details.
    @option params {String} email_type change the email type preference for the member ("html" or "text").  Leave blank to keep the existing preference (optional)
    @option params {Boolean} replace_interests flag to determine whether we replace the interest groups with the updated groups provided, or we add the provided groups to the member's interest groups (optional, defaults to true)
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    updateMember: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror

        params["email_type"] ?= ''
        params["replace_interests"] ?= true

        @master.call('lists/update-member', params, onsuccess, onerror)

    ###
    Add a new Webhook URL for the given list
    @param {Object} params the hash of the parameters to pass to the request
    @option params {String} id the list id to connect to. Get by calling lists/list()
    @option params {String} url a valid URL for the Webhook - it will be validated. note that a url may only exist on a list once.
    @option params {Struct} actions optional a hash of actions to fire this Webhook for
         - subscribe {Bool} optional as subscribes occur, defaults to true
         - unsubscribe {Bool} optional as subscribes occur, defaults to true
         - profile {Bool} optional as profile updates occur, defaults to true
         - cleaned {Bool} optional as emails are cleaned from the list, defaults to true
         - upemail {Bool} optional when  subscribers change their email address, defaults to true
         - campaign {Bool} option when a campaign is sent or canceled, defaults to true
    @option params {Struct} sources optional  sources to fire this Webhook for
         - user {Bool} optional user/subscriber initiated actions, defaults to true
         - admin {Bool} optional admin actions in our web app, defaults to true
         - api {Bool} optional actions that happen via API calls, defaults to false
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    webhookAdd: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror

        params["actions"] ?= []
        params["sources"] ?= []

        @master.call('lists/webhook-add', params, onsuccess, onerror)

    ###
    Delete an existing Webhook URL from a given list
    @param {Object} params the hash of the parameters to pass to the request
    @option params {String} id the list id to connect to. Get by calling lists/list()
    @option params {String} url the URL of a Webhook on this list
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    webhookDel: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror


        @master.call('lists/webhook-del', params, onsuccess, onerror)

    ###
    Return the Webhooks configured for the given list
    @param {Object} params the hash of the parameters to pass to the request
    @option params {String} id the list id to connect to. Get by calling lists/list()
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    webhooks: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror


        @master.call('lists/webhooks', params, onsuccess, onerror)

    ###
    Retrieve all of the lists defined for your user account
    @param {Object} params the hash of the parameters to pass to the request
    @option params {Struct} filters filters to apply to this query - all are optional:
         - list_id {String} optional - return a single list using a known list_id. Accepts multiples separated by commas when not using exact matching
         - list_name {String} optional - only lists that match this name
         - from_name {String} optional - only lists that have a default from name matching this
         - from_email {String} optional - only lists that have a default from email matching this
         - from_subject {String} optional - only lists that have a default from email matching this
         - created_before {String} optional - only show lists that were created before this date+time  - 24 hour format in <strong>GMT</strong>, eg "2013-12-30 20:30:00"
         - created_after {String} optional - only show lists that were created since this date+time  - 24 hour format in <strong>GMT</strong>, eg "2013-12-30 20:30:00"
         - exact {Boolean} optional - flag for whether to filter on exact values when filtering, or search within content for filter values - defaults to false
    @option params {Int} start optional - control paging of lists, start results at this list #, defaults to 1st page of data  (page 0)
    @option params {Int} limit optional - control paging of lists, number of lists to return with each call, defaults to 25 (max=100)
    @option params {String} sort_field optional - "created" (the created date, default) or "web" (the display order in the web app). Invalid values will fall back on "created" - case insensitive.
    @option params {String} sort_dir optional - "DESC" for descending (default), "ASC" for Ascending.  Invalid values will fall back on "created" - case insensitive. Note: to get the exact display order as the web app you'd use "web" and "ASC"
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    list: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror

        params["filters"] ?= []
        params["start"] ?= 0
        params["limit"] ?= 25
        params["sort_field"] ?= 'created'
        params["sort_dir"] ?= 'DESC'

        @master.call('lists/list', params, onsuccess, onerror)
class Campaigns
    constructor: (@master) ->


    ###
    Get the content (both html and text) for a campaign either as it would appear in the campaign archive or as the raw, original content
    @param {Object} params the hash of the parameters to pass to the request
    @option params {String} cid the campaign id to get content for (can be gathered using campaigns/list())
    @option params {Struct} options various options to control this call
         - view {String} optional one of "archive" (default), "preview" (like our popup-preview) or "raw"
         - email {Object} optional if provided, view is "archive" or "preview", the campaign's list still exists, and the requested record is subscribed to the list. the returned content will be populated with member data populated. a struct with one of the following keys - failing to provide anything will produce an error relating to the email address. If multiple keys are provided, the first one from the following list that we find will be used, the rest will be ignored.
             - email {String} an email address
             - euid {String} the unique id for an email address (not list related) - the email "id" returned from listMemberInfo, Webhooks, Campaigns, etc.
             - leid {String} the list email id (previously called web_id) for a list-member-info type call. this doesn't change when the email address changes
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    content: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror

        params["options"] ?= []

        @master.call('campaigns/content', params, onsuccess, onerror)

    ###
    Create a new draft campaign to send. You <strong>can not</strong> have more than 32,000 campaigns in your account.
    @param {Object} params the hash of the parameters to pass to the request
    @option params {String} type the Campaign Type to create - one of "regular", "plaintext", "absplit", "rss", "auto"
    @option params {Struct} options a struct of the standard options for this campaign :
         - list_id {String} the list to send this campaign to- get lists using lists/list()
         - subject {String} the subject line for your campaign message
         - from_email {String} the From: email address for your campaign message
         - from_name {String} the From: name for your campaign message (not an email address)
         - to_name {String} the To: name recipients will see (not email address)
         - template_id {Int} optional - use this user-created template to generate the HTML content of the campaign (takes precendence over other template options)
         - gallery_template_id {Int} optional - use a template from the public gallery to generate the HTML content of the campaign (takes precendence over base template options)
         - base_template_id {Int} optional - use this a base/start-from-scratch template to generate the HTML content of the campaign
         - folder_id {Int} optional - automatically file the new campaign in the folder_id passed. Get using folders/list() - note that Campaigns and Autoresponders have separate folder setups
         - tracking {Object} optional - set which recipient actions will be tracked. Click tracking can not be disabled for Free accounts.
             - opens {Bool} whether to track opens, defaults to true
             - html_clicks {Bool} whether to track clicks in HTML content, defaults to true
             - text_clicks {Bool} whether to track clicks in Text content, defaults to false
         - title {String} optional - an internal name to use for this campaign.  By default, the campaign subject will be used.
         - authenticate {Boolean} optional - set to true to enable SenderID, DomainKeys, and DKIM authentication, defaults to false.
         - analytics {Object} optional - one or more of these keys set to the tag to use - that can be any custom text (up to 50 bytes)
             - google {String} for Google Analytics  tracking
             - clicktale {String} for ClickTale  tracking
             - gooal {String} for Goal tracking (the extra 'o' in the param name is not a typo)
         - auto_footer {Boolean} optional Whether or not we should auto-generate the footer for your content. Mostly useful for content from URLs or Imports
         - inline_css {Boolean} optional Whether or not css should be automatically inlined when this campaign is sent, defaults to false.
         - generate_text {Boolean} optional Whether of not to auto-generate your Text content from the HTML content. Note that this will be ignored if the Text part of the content passed is not empty, defaults to false.
         - auto_tweet {Boolean} optional If set, this campaign will be auto-tweeted when it is sent - defaults to false. Note that if a Twitter account isn't linked, this will be silently ignored.
         - auto_fb_post {Array} optional If set, this campaign will be auto-posted to the page_ids contained in the array. If a Facebook account isn't linked or the account does not have permission to post to the page_ids requested, those failures will be silently ignored.
         - fb_comments {Boolean} optional If true, the Facebook comments (and thus the <a href="http://kb.mailchimp.com/article/i-dont-want-an-archiave-of-my-campaign-can-i-turn-it-off/" target="_blank">archive bar</a> will be displayed. If false, Facebook comments will not be enabled (does not imply no archive bar, see previous link). Defaults to "true".
         - timewarp {Boolean} optional If set, this campaign must be scheduled 24 hours in advance of sending - default to false. Only valid for "regular" campaigns and "absplit" campaigns that split on schedule_time.
         - ecomm360 {Boolean} optional If set, our <a href="http://www.mailchimp.com/blog/ecommerce-tracking-plugin/" target="_blank">Ecommerce360 tracking</a> will be enabled for links in the campaign
         - crm_tracking {Object} optional If set, a struct to enable CRM tracking for:
             - salesforce {Object} optional Enable SalesForce push back
                 - campaign {Bool} optional - if true, create a Campaign object and update it with aggregate stats
                 - notes {Bool} optional - if true, attempt to update Contact notes based on email address
             - highrise {Object} optional Enable Highrise push back
                 - campaign {Bool} optional - if true, create a Kase object and update it with aggregate stats
                 - notes {Bool} optional - if true, attempt to update Contact notes based on email address
             - capsule {Object} optional Enable Capsule push back (only notes are supported)
                 - notes {Bool} optional - if true, attempt to update Contact notes based on email address
    @option params {Struct} content the content for this campaign - use a struct with the one of the following keys:
         - html {String} for raw/pasted HTML content
         - sections {Object} when using a template instead of raw HTML, each key should be the unique mc:edit area name from the template.
         - text {String} for the plain-text version
         - url {String} to have us pull in content from a URL. Note, this will override any other content options - for lists with Email Format options, you'll need to turn on generate_text as well
         - archive {String} to send a Base64 encoded archive file for us to import all media from. Note, this will override any other content options - for lists with Email Format options, you'll need to turn on generate_text as well
         - archive_type {String} optional - only necessary for the "archive" option. Supported formats are: zip, tar.gz, tar.bz2, tar, tgz, tbz . If not included, we will default to zip
    @option params {Struct} segment_opts if you wish to do Segmentation with this campaign this array should contain: see campaigns/segment-test(). It's suggested that you test your options against campaigns/segment-test().
    @option params {Struct} type_opts various extra options based on the campaign type
         - rss {Object} For RSS Campaigns this, struct should contain:
             - url {String} the URL to pull RSS content from - it will be verified and must exist
             - schedule {String} optional one of "daily", "weekly", "monthly" - defaults to "daily"
             - schedule_hour {String} optional an hour between 0 and 24 - default to 4 (4am <em>local time</em>) - applies to all schedule types
             - schedule_weekday {String} optional for "weekly" only, a number specifying the day of the week to send: 0 (Sunday) - 6 (Saturday) - defaults to 1 (Monday)
             - schedule_monthday {String} optional for "monthly" only, a number specifying the day of the month to send (1 - 28) or "last" for the last day of a given month. Defaults to the 1st day of the month
             - days {Object} optional used for "daily" schedules only, an array of the <a href="http://en.wikipedia.org/wiki/ISO-8601#Week_dates" target="_blank">ISO-8601 weekday numbers</a> to send on
                 - 1 {Bool} optional Monday, defaults to true
                 - 2 {Bool} optional Tuesday, defaults to true
                 - 3 {Bool} optional Wednesday, defaults to true
                 - 4 {Bool} optional Thursday, defaults to true
                 - 5 {Bool} optional Friday, defaults to true
                 - 6 {Bool} optional Saturday, defaults to true
                 - 7 {Bool} optional Sunday, defaults to true
         - absplit {Object} For A/B Split campaigns, this struct should contain:
             - split_test {String} The values to segment based on. Currently, one of: "subject", "from_name", "schedule". NOTE, for "schedule", you will need to call campaigns/schedule() separately!
             - pick_winner {String} How the winner will be picked, one of: "opens" (by the open_rate), "clicks" (by the click rate), "manual" (you pick manually)
             - wait_units {Int} optional the default time unit to wait before auto-selecting a winner - use "3600" for hours, "86400" for days. Defaults to 86400.
             - wait_time {Int} optional the number of units to wait before auto-selecting a winner - defaults to 1, so if not set, a winner will be selected after 1 Day.
             - split_size {Int} optional this is a percentage of what size the Campaign's List plus any segmentation options results in. "schedule" type forces 50%, all others default to 10%
             - from_name_a {String} optional sort of, required when split_test is "from_name"
             - from_name_b {String} optional sort of, required when split_test is "from_name"
             - from_email_a {String} optional sort of, required when split_test is "from_name"
             - from_email_b {String} optional sort of, required when split_test is "from_name"
             - subject_a {String} optional sort of, required when split_test is "subject"
             - subject_b {String} optional sort of, required when split_test is "subject"
         - auto {Object} For AutoResponder campaigns, this struct should contain:
             - offset-units {String} one of "hourly", "day", "week", "month", "year" - required
             - offset-time {String} optional, sort of - the number of units must be a number greater than 0 for signup based autoresponders, ignored for "hourly"
             - offset-dir {String} either "before" or "after", ignored for "hourly"
             - event {String} optional "signup" (default) to base this members added to a list, "date", "annual", or "birthday" to base this on merge field in the list, "campaignOpen" or "campaignClicka" to base this on any activity for a campaign, "campaignClicko" to base this on clicks on a specific URL in a campaign, "mergeChanged" to base this on a specific merge field being changed to a specific value
             - event-datemerge {String} optional sort of, this is required if the event is "date", "annual", "birthday", or "mergeChanged"
             - campaign_id {String} optional sort of, required for "campaignOpen", "campaignClicka", or "campaignClicko"
             - campaign_url {String} optional sort of, required for "campaignClicko"
             - schedule_hour {Int} The hour of the day - 24 hour format in GMT - the autoresponder should be triggered, ignored for "hourly"
             - use_import_time {Boolean} whether or not imported subscribers (ie, <em>any</em> non-double optin subscribers) will receive
             - days {Object} optional used for "daily" schedules only, an array of the <a href="http://en.wikipedia.org/wiki/ISO-8601#Week_dates" target="_blank">ISO-8601 weekday numbers</a> to send on<
                 - 1 {Bool} optional Monday, defaults to true
                 - 2 {Bool} optional Tuesday, defaults to true
                 - 3 {Bool} optional Wednesday, defaults to true
                 - 4 {Bool} optional Thursday, defaults to true
                 - 5 {Bool} optional Friday, defaults to true
                 - 6 {Bool} optional Saturday, defaults to true
                 - 7 {Bool} optional Sunday, defaults to true
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    create: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror

        params["segment_opts"] ?= null
        params["type_opts"] ?= null

        @master.call('campaigns/create', params, onsuccess, onerror)

    ###
    Delete a campaign. Seriously, "poof, gone!" - be careful! Seriously, no one can undelete these.
    @param {Object} params the hash of the parameters to pass to the request
    @option params {String} cid the Campaign Id to delete
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    delete: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror


        @master.call('campaigns/delete', params, onsuccess, onerror)

    ###
    Get the list of campaigns and their details matching the specified filters
    @param {Object} params the hash of the parameters to pass to the request
    @option params {Struct} filters a struct of filters to apply to this query - all are optional:
         - campaign_id {String} optional - return the campaign using a know campaign_id.  Accepts multiples separated by commas when not using exact matching.
         - parent_id {String} optional - return the child campaigns using a known parent campaign_id.  Accepts multiples separated by commas when not using exact matching.
         - list_id {String} optional - the list to send this campaign to - get lists using lists/list(). Accepts multiples separated by commas when not using exact matching.
         - folder_id {Int} optional - only show campaigns from this folder id - get folders using folders/list(). Accepts multiples separated by commas when not using exact matching.
         - template_id {Int} optional - only show campaigns using this template id - get templates using templates/list(). Accepts multiples separated by commas when not using exact matching.
         - status {String} optional - return campaigns of a specific status - one of "sent", "save", "paused", "schedule", "sending". Accepts multiples separated by commas when not using exact matching.
         - type {String} optional - return campaigns of a specific type - one of "regular", "plaintext", "absplit", "rss", "auto". Accepts multiples separated by commas when not using exact matching.
         - from_name {String} optional - only show campaigns that have this "From Name"
         - from_email {String} optional - only show campaigns that have this "Reply-to Email"
         - title {String} optional - only show campaigns that have this title
         - subject {String} optional - only show campaigns that have this subject
         - sendtime_start {String} optional - only show campaigns that have been sent since this date/time (in GMT) -  - 24 hour format in <strong>GMT</strong>, eg "2013-12-30 20:30:00" - if this is invalid the whole call fails
         - sendtime_end {String} optional - only show campaigns that have been sent before this date/time (in GMT) -  - 24 hour format in <strong>GMT</strong>, eg "2013-12-30 20:30:00" - if this is invalid the whole call fails
         - uses_segment {Boolean} - whether to return just campaigns with or without segments
         - exact {Boolean} optional - flag for whether to filter on exact values when filtering, or search within content for filter values - defaults to true. Using this disables the use of any filters that accept multiples.
    @option params {Int} start optional - control paging of campaigns, start results at this campaign #, defaults to 1st page of data  (page 0)
    @option params {Int} limit optional - control paging of campaigns, number of campaigns to return with each call, defaults to 25 (max=1000)
    @option params {String} sort_field optional - one of "create_time", "send_time", "title", "subject" . Invalid values will fall back on "create_time" - case insensitive.
    @option params {String} sort_dir optional - "DESC" for descending (default), "ASC" for Ascending.  Invalid values will fall back on "DESC" - case insensitive.
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    list: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror

        params["filters"] ?= []
        params["start"] ?= 0
        params["limit"] ?= 25
        params["sort_field"] ?= 'create_time'
        params["sort_dir"] ?= 'DESC'

        @master.call('campaigns/list', params, onsuccess, onerror)

    ###
    Pause an AutoResponder or RSS campaign from sending
    @param {Object} params the hash of the parameters to pass to the request
    @option params {String} cid the id of the campaign to pause
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    pause: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror


        @master.call('campaigns/pause', params, onsuccess, onerror)

    ###
    Returns information on whether a campaign is ready to send and possible issues we may have detected with it - very similar to the confirmation step in the app.
    @param {Object} params the hash of the parameters to pass to the request
    @option params {String} cid the Campaign Id to replicate
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    ready: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror


        @master.call('campaigns/ready', params, onsuccess, onerror)

    ###
    Replicate a campaign.
    @param {Object} params the hash of the parameters to pass to the request
    @option params {String} cid the Campaign Id to replicate
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    replicate: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror


        @master.call('campaigns/replicate', params, onsuccess, onerror)

    ###
    Resume sending an AutoResponder or RSS campaign
    @param {Object} params the hash of the parameters to pass to the request
    @option params {String} cid the id of the campaign to resume
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    resume: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror


        @master.call('campaigns/resume', params, onsuccess, onerror)

    ###
    Schedule a campaign to be sent in the future
    @param {Object} params the hash of the parameters to pass to the request
    @option params {String} cid the id of the campaign to schedule
    @option params {String} schedule_time the time to schedule the campaign. For A/B Split "schedule" campaigns, the time for Group A - 24 hour format in <strong>GMT</strong>, eg "2013-12-30 20:30:00"
    @option params {String} schedule_time_b optional -the time to schedule Group B of an A/B Split "schedule" campaign  - 24 hour format in <strong>GMT</strong>, eg "2013-12-30 20:30:00"
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    schedule: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror

        params["schedule_time_b"] ?= null

        @master.call('campaigns/schedule', params, onsuccess, onerror)

    ###
    Schedule a campaign to be sent in batches sometime in the future. Only valid for "regular" campaigns
    @param {Object} params the hash of the parameters to pass to the request
    @option params {String} cid the id of the campaign to schedule
    @option params {String} schedule_time the time to schedule the campaign.
    @option params {Int} num_batches optional - the number of batches between 2 and 26 to send. defaults to 2
    @option params {Int} stagger_mins optional - the number of minutes between each batch - 5, 10, 15, 20, 25, 30, or 60. defaults to 5
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    scheduleBatch: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror

        params["num_batches"] ?= 2
        params["stagger_mins"] ?= 5

        @master.call('campaigns/schedule-batch', params, onsuccess, onerror)

    ###
    Allows one to test their segmentation rules before creating a campaign using them.
    @param {Object} params the hash of the parameters to pass to the request
    @option params {String} list_id the list to test segmentation on - get lists using lists/list()
    @option params {Struct} options with 1 or 2 keys:
         - saved_segment_id {String} a saved segment id from lists/segments() - this will take precendence, otherwise the match+conditions are required.
         - match {String} controls whether to use AND or OR when applying your options - expects "<strong>any</strong>" (for OR) or "<strong>all</strong>" (for AND)
         - conditions {Array} of up to 5 structs for different criteria to apply while segmenting. Each criteria row must contain 3 keys - "<strong>field</strong>", "<strong>op</strong>", and "<strong>value</strong>" - and possibly a fourth, "<strong>extra</strong>", based on these definitions:
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    segmentTest: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror


        @master.call('campaigns/segment-test', params, onsuccess, onerror)

    ###
    Send a given campaign immediately. For RSS campaigns, this will "start" them.
    @param {Object} params the hash of the parameters to pass to the request
    @option params {String} cid the id of the campaign to send
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    send: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror


        @master.call('campaigns/send', params, onsuccess, onerror)

    ###
    Send a test of this campaign to the provided email addresses
    @param {Object} params the hash of the parameters to pass to the request
    @option params {String} cid the id of the campaign to test
    @option params {Array} test_emails an array of email address to receive the test message
    @option params {String} send_type by default just html is sent - can be "html" or "text" send specify the format
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    sendTest: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror

        params["test_emails"] ?= []
        params["send_type"] ?= 'html'

        @master.call('campaigns/send-test', params, onsuccess, onerror)

    ###
    Get the HTML template content sections for a campaign. Note that this <strong>will</strong> return very jagged, non-standard results based on the template
a campaign is using. You only want to use this if you want to allow editing template sections in your application.
    @param {Object} params the hash of the parameters to pass to the request
    @option params {String} cid the campaign id to get content for (can be gathered using campaigns/list())
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    templateContent: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror


        @master.call('campaigns/template-content', params, onsuccess, onerror)

    ###
    Unschedule a campaign that is scheduled to be sent in the future
    @param {Object} params the hash of the parameters to pass to the request
    @option params {String} cid the id of the campaign to unschedule
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    unschedule: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror


        @master.call('campaigns/unschedule', params, onsuccess, onerror)

    ###
    Update just about any setting besides type for a campaign that has <em>not</em> been sent. See campaigns/create() for details.
Caveats:<br/><ul class='bullets'>
<li>If you set a new list_id, all segmentation options will be deleted and must be re-added.</li>
<li>If you set template_id, you need to follow that up by setting it's 'content'</li>
<li>If you set segment_opts, you should have tested your options against campaigns/segment-test().</li>
<li>To clear/unset segment_opts, pass an empty string or array as the value. Various wrappers may require one or the other.</li>
</ul>
    @param {Object} params the hash of the parameters to pass to the request
    @option params {String} cid the Campaign Id to update
    @option params {String} name the parameter name ( see campaigns/create() ). This will be that parameter name (options, content, segment_opts) except "type_opts", which will be the name of the type - rss, auto, etc. The campaign "type" can not be changed.
    @option params {Array} value an appropriate set of values for the parameter ( see campaigns/create() ). For additional parameters, this is the same value passed to them.
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    update: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror


        @master.call('campaigns/update', params, onsuccess, onerror)
class Vip
    constructor: (@master) ->


    ###
    Retrieve all Activity (opens/clicks) for VIPs over the past 10 days
    @param {Object} params the hash of the parameters to pass to the request
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    activity: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror


        @master.call('vip/activity', params, onsuccess, onerror)

    ###
    Add VIPs (previously called Golden Monkeys)
    @param {Object} params the hash of the parameters to pass to the request
    @option params {String} id the list id to connect to. Get by calling lists/list()
    @option params {Array} emails an array of up to 50 email address structs to add, each with with one of the following keys
         - email {String} an email address - for new subscribers obviously this should be used
         - euid {String} the unique id for an email address (not list related) - the email "id" returned from listMemberInfo, Webhooks, Campaigns, etc.
         - leid {String} the list email id (previously called web_id) for a list-member-info type call. this doesn't change when the email address changes
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    add: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror


        @master.call('vip/add', params, onsuccess, onerror)

    ###
    Remove VIPs - this does not affect list membership
    @param {Object} params the hash of the parameters to pass to the request
    @option params {String} id the list id to connect to. Get by calling lists/list()
    @option params {Array} emails an array of up to 50 email address structs to remove, each with with one of the following keys
         - email {String} an email address - for new subscribers obviously this should be used
         - euid {String} the unique id for an email address (not list related) - the email "id" returned from listMemberInfo, Webhooks, Campaigns, etc.
         - leid {String} the list email id (previously called web_id) for a list-member-info type call. this doesn't change when the email address changes
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    del: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror


        @master.call('vip/del', params, onsuccess, onerror)

    ###
    Retrieve all Golden Monkey(s) for an account
    @param {Object} params the hash of the parameters to pass to the request
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    members: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror


        @master.call('vip/members', params, onsuccess, onerror)
class Reports
    constructor: (@master) ->


    ###
    Get all email addresses that complained about a given campaign
    @param {Object} params the hash of the parameters to pass to the request
    @option params {String} cid the campaign id to pull abuse reports for (can be gathered using campaigns/list())
    @option params {Struct} opts various options for controlling returned data
         - start {Int} optional for large data sets, the page number to start at - defaults to 1st page of data  (page 0)
         - limit {Int} optional for large data sets, the number of results to return - defaults to 25, upper limit set at 100
         - since {String} optional pull only messages since this time - 24 hour format in <strong>GMT</strong>, eg "2013-12-30 20:30:00"
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    abuse: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror

        params["opts"] ?= []

        @master.call('reports/abuse', params, onsuccess, onerror)

    ###
    Retrieve the text presented in our app for how a campaign performed and any advice we may have for you - best
suited for display in customized reports pages. Note: some messages will contain HTML - clean tags as necessary
    @param {Object} params the hash of the parameters to pass to the request
    @option params {String} cid the campaign id to pull advice text for (can be gathered using campaigns/list())
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    advice: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror


        @master.call('reports/advice', params, onsuccess, onerror)

    ###
    Retrieve the most recent full bounce message for a specific email address on the given campaign.
Messages over 30 days old are subject to being removed
    @param {Object} params the hash of the parameters to pass to the request
    @option params {String} cid the campaign id to pull bounces for (can be gathered using campaigns/list())
    @option params {Struct} email a struct with one of the following keys - failing to provide anything will produce an error relating to the email address. If multiple keys are provided, the first one from the following list that we find will be used, the rest will be ignored.
         - email {String} an email address - this is recommended for this method
         - euid {String} the unique id for an email address (not list related) - the email "id" returned from listMemberInfo, Webhooks, Campaigns, etc.
         - leid {String} the list email id (previously called web_id) for a list-member-info type call. this doesn't change when the email address changes
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    bounceMessage: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror


        @master.call('reports/bounce-message', params, onsuccess, onerror)

    ###
    Retrieve the full bounce messages for the given campaign. Note that this can return very large amounts
of data depending on how large the campaign was and how much cruft the bounce provider returned. Also,
messages over 30 days old are subject to being removed
    @param {Object} params the hash of the parameters to pass to the request
    @option params {String} cid the campaign id to pull bounces for (can be gathered using campaigns/list())
    @option params {Struct} opts various options for controlling returned data
         - start {Int} optional for large data sets, the page number to start at - defaults to 1st page of data  (page 0)
         - limit {Int} optional for large data sets, the number of results to return - defaults to 25, upper limit set at 100
         - since {String} optional pull only messages since this time - 24 hour format in <strong>GMT</strong>, eg "2013-12-30 20:30:00"
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    bounceMessages: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror

        params["opts"] ?= []

        @master.call('reports/bounce-messages', params, onsuccess, onerror)

    ###
    Return the list of email addresses that clicked on a given url, and how many times they clicked
    @param {Object} params the hash of the parameters to pass to the request
    @option params {String} cid the campaign id to get click stats for (can be gathered using campaigns/list())
    @option params {Int} tid the "tid" for the URL from reports/clicks
    @option params {Struct} opts various options for controlling returned data
         - start {Int} optional for large data sets, the page number to start at - defaults to 1st page of data  (page 0)
         - limit {Int} optional for large data sets, the number of results to return - defaults to 25, upper limit set at 100
         - sort_field {String} optional the data to sort by - "clicked" (order clicks occurred, default) or "clicks" (total number of opens). Invalid fields will fall back on the default.
         - sort_dir {String} optional the direct - ASC or DESC. defaults to ASC (case insensitive)
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    clickDetail: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror

        params["opts"] ?= []

        @master.call('reports/click-detail', params, onsuccess, onerror)

    ###
    The urls tracked and their click counts for a given campaign.
    @param {Object} params the hash of the parameters to pass to the request
    @option params {String} cid the campaign id to pull stats for (can be gathered using campaigns/list())
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    clicks: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror


        @master.call('reports/clicks', params, onsuccess, onerror)

    ###
    Retrieve the Ecommerce Orders tracked by ecomm/order-add()
    @param {Object} params the hash of the parameters to pass to the request
    @option params {String} cid the campaign id to pull orders for for (can be gathered using campaigns/list())
    @option params {Struct} opts various options for controlling returned data
         - start {Int} optional for large data sets, the page number to start at - defaults to 1st page of data  (page 0)
         - limit {Int} optional for large data sets, the number of results to return - defaults to 25, upper limit set at 100
         - since {String} optional pull only messages since this time - 24 hour format in <strong>GMT</strong>, eg "2013-12-30 20:30:00"
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    ecommOrders: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror

        params["opts"] ?= []

        @master.call('reports/ecomm-orders', params, onsuccess, onerror)

    ###
    Retrieve the eepurl stats from the web/Twitter mentions for this campaign
    @param {Object} params the hash of the parameters to pass to the request
    @option params {String} cid the campaign id to pull stats for (can be gathered using campaigns/list())
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    eepurl: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror


        @master.call('reports/eepurl', params, onsuccess, onerror)

    ###
    Given a campaign and email address, return the entire click and open history with timestamps, ordered by time. If you need to dump the full activity for a campaign
and/or get incremental results, you should use the <a href="http://apidocs.mailchimp.com/export/1.0/campaignsubscriberactivity.func.php" targret="_new">campaignSubscriberActivity Export API method</a>,
<strong>not</strong> this, especially for large campaigns.
    @param {Object} params the hash of the parameters to pass to the request
    @option params {String} cid the campaign id to get stats for (can be gathered using campaigns/list())
    @option params {Array} emails an array of up to 50 email address struct to retrieve activity information for
         - email {String} an email address
         - euid {String} the unique id for an email address (not list related) - the email "id" returned from listMemberInfo, Webhooks, Campaigns, etc.
         - leid {String} the list email id (previously called web_id) for a list-member-info type call. this doesn't change when the email address changes
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    memberActivity: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror


        @master.call('reports/member-activity', params, onsuccess, onerror)

    ###
    Retrieve the list of email addresses that did not open a given campaign
    @param {Object} params the hash of the parameters to pass to the request
    @option params {String} cid the campaign id to get no opens for (can be gathered using campaigns/list())
    @option params {Struct} opts various options for controlling returned data
         - start {Int} optional for large data sets, the page number to start at - defaults to 1st page of data  (page 0)
         - limit {Int} optional for large data sets, the number of results to return - defaults to 25, upper limit set at 100
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    notOpened: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror

        params["opts"] ?= []

        @master.call('reports/not-opened', params, onsuccess, onerror)

    ###
    Retrieve the list of email addresses that opened a given campaign with how many times they opened
    @param {Object} params the hash of the parameters to pass to the request
    @option params {String} cid the campaign id to get opens for (can be gathered using campaigns/list())
    @option params {Struct} opts various options for controlling returned data
         - start {Int} optional for large data sets, the page number to start at - defaults to 1st page of data  (page 0)
         - limit {Int} optional for large data sets, the number of results to return - defaults to 25, upper limit set at 100
         - sort_field {String} optional the data to sort by - "opened" (order opens occurred, default) or "opens" (total number of opens). Invalid fields will fall back on the default.
         - sort_dir {String} optional the direct - ASC or DESC. defaults to ASC (case insensitive)
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    opened: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror

        params["opts"] ?= []

        @master.call('reports/opened', params, onsuccess, onerror)

    ###
    Get the top 5 performing email domains for this campaign. Users wanting more than 5 should use campaign reports/member-activity()
or campaignEmailStatsAIMAll() and generate any additional stats they require.
    @param {Object} params the hash of the parameters to pass to the request
    @option params {String} cid the campaign id to pull email domain performance for (can be gathered using campaigns/list())
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    domainPerformance: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror


        @master.call('reports/domain-performance', params, onsuccess, onerror)

    ###
    Retrieve the countries/regions and number of opens tracked for each. Email address are not returned.
    @param {Object} params the hash of the parameters to pass to the request
    @option params {String} cid the campaign id to pull bounces for (can be gathered using campaigns/list())
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    geoOpens: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror


        @master.call('reports/geo-opens', params, onsuccess, onerror)

    ###
    Retrieve the Google Analytics data we've collected for this campaign. Note, requires Google Analytics Add-on to be installed and configured.
    @param {Object} params the hash of the parameters to pass to the request
    @option params {String} cid the campaign id to pull bounces for (can be gathered using campaigns/list())
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    googleAnalytics: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror


        @master.call('reports/google-analytics', params, onsuccess, onerror)

    ###
    Get email addresses the campaign was sent to
    @param {Object} params the hash of the parameters to pass to the request
    @option params {String} cid the campaign id to pull members for (can be gathered using campaigns/list())
    @option params {Struct} opts various options for controlling returned data
         - status {String} optional the status to pull - one of 'sent', 'hard' (bounce), or 'soft' (bounce). By default, all records are returned
         - start {Int} optional for large data sets, the page number to start at - defaults to 1st page of data  (page 0)
         - limit {Int} optional for large data sets, the number of results to return - defaults to 25, upper limit set at 100
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    sentTo: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror

        params["opts"] ?= []

        @master.call('reports/sent-to', params, onsuccess, onerror)

    ###
    Get the URL to a customized <a href="http://eepurl.com/gKmL" target="_blank">VIP Report</a> for the specified campaign and optionally send an email to someone with links to it. Note subsequent calls will overwrite anything already set for the same campign (eg, the password)
    @param {Object} params the hash of the parameters to pass to the request
    @option params {String} cid the campaign id to share a report for (can be gathered using campaigns/list())
    @option params {Array} opts optional various parameters which can be used to configure the shared report
         - to_email {String} optional - optional, comma delimited list of email addresses to share the report with - no value means an email will not be sent
         - theme_id {Int} optional - either a global or a user-specific theme id. Currently this needs to be pulled out of either the Share Report or Cobranding web views by grabbing the "theme" attribute from the list presented.
         - css_url {String} optional - a link to an external CSS file to be included after our default CSS (http://vip-reports.net/css/vip.css) <strong>only if</strong> loaded via the "secure_url" - max 255 bytes
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    share: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror

        params["opts"] ?= []

        @master.call('reports/share', params, onsuccess, onerror)

    ###
    Retrieve relevant aggregate campaign statistics (opens, bounces, clicks, etc.)
    @param {Object} params the hash of the parameters to pass to the request
    @option params {String} cid the campaign id to pull stats for (can be gathered using campaigns/list())
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    summary: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror


        @master.call('reports/summary', params, onsuccess, onerror)

    ###
    Get all unsubscribed email addresses for a given campaign
    @param {Object} params the hash of the parameters to pass to the request
    @option params {String} cid the campaign id to pull bounces for (can be gathered using campaigns/list())
    @option params {Struct} opts various options for controlling returned data
         - start {Int} optional for large data sets, the page number to start at - defaults to 1st page of data  (page 0)
         - limit {Int} optional for large data sets, the number of results to return - defaults to 25, upper limit set at 100
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    unsubscribes: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror

        params["opts"] ?= []

        @master.call('reports/unsubscribes', params, onsuccess, onerror)
class Gallery
    constructor: (@master) ->


    ###
    Return a section of the image gallery
    @param {Object} params the hash of the parameters to pass to the request
    @option params {Struct} opts various options for controlling returned data
         - type {String} optional the gallery type to return - images or files - default to images
         - start {Int} optional for large data sets, the page number to start at - defaults to 1st page of data  (page 0)
         - limit {Int} optional for large data sets, the number of results to return - defaults to 25, upper limit set at 100
         - sort_by {String} optional field to sort by - one of size, time, name - defaults to time
         - sort_dir {String} optional field to sort by - one of asc, desc - defaults to desc
         - search_term {String} optional a term to search for in names
         - folder_id {Int} optional to return files that are in a specific folder.  id returned by the list-folders call
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    list: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror

        params["opts"] ?= []

        @master.call('gallery/list', params, onsuccess, onerror)

    ###
    Return a list of the folders available to the file gallery
    @param {Object} params the hash of the parameters to pass to the request
    @option params {Struct} opts various options for controlling returned data
         - start {Int} optional for large data sets, the page number to start at - defaults to 1st page of data  (page 0)
         - limit {Int} optional for large data sets, the number of results to return - defaults to 25, upper limit set at 100
         - search_term {String} optional a term to search for in names
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    listFolders: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror

        params["opts"] ?= []

        @master.call('gallery/list-folders', params, onsuccess, onerror)

    ###
    Adds a folder to the file gallery
    @param {Object} params the hash of the parameters to pass to the request
    @option params {String} name the name of the folder to add (255 character max)
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    addFolder: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror


        @master.call('gallery/add-folder', params, onsuccess, onerror)

    ###
    Remove a folder
    @param {Object} params the hash of the parameters to pass to the request
    @option params {Int} folder_id the id of the folder to remove, as returned by the listFolders call
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    removeFolder: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror


        @master.call('gallery/remove-folder', params, onsuccess, onerror)

    ###
    Add a file to a folder
    @param {Object} params the hash of the parameters to pass to the request
    @option params {Int} file_id the id of the file you want to add to a folder, as returned by the list call
    @option params {Int} folder_id the id of the folder to add the file to, as returned by the listFolders call
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    addFileToFolder: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror


        @master.call('gallery/add-file-to-folder', params, onsuccess, onerror)

    ###
    Remove a file from a folder
    @param {Object} params the hash of the parameters to pass to the request
    @option params {Int} file_id the id of the file you want to remove from the folder, as returned by the list call
    @option params {Int} folder_id the id of the folder to remove the file from, as returned by the listFolders call
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    removeFileFromFolder: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror


        @master.call('gallery/remove-file-from-folder', params, onsuccess, onerror)

    ###
    Remove all files from a folder (Note that the files are not deleted, they are only removed from the folder)
    @param {Object} params the hash of the parameters to pass to the request
    @option params {Int} folder_id the id of the folder to remove the file from, as returned by the listFolders call
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    removeAllFilesFromFolder: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror


        @master.call('gallery/remove-all-files-from-folder', params, onsuccess, onerror)
class Goal
    constructor: (@master) ->


    ###
    Retrieve goal event data for a particular list member. Note: only unique events are returned. If a user triggers
a particular event multiple times, you will still only receive one entry for that event.
    @param {Object} params the hash of the parameters to pass to the request
    @option params {String} list_id the list id to connect to. Get by calling lists/list()
    @option params {Struct} email a struct with one of the following keys - failing to provide anything will produce an error relating to the email address. If multiple keys are provided, the first one from the following list that we find will be used, the rest will be ignored.
         - email {String} an email address
         - euid {String} the unique id for an email address (not list related) - the email "id" returned from listMemberInfo, Webhooks, Campaigns, etc.
         - leid {String} the list email id (previously called web_id) for a list-member-info type call. this doesn't change when the email address changes
    @option params {Int} start optional - control paging of lists, start results at this list #, defaults to 1st page of data  (page 0)
    @option params {Int} limit optional - control paging of lists, number of lists to return with each call, defaults to 25 (max=100)
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    events: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror

        params["start"] ?= 0
        params["limit"] ?= 25

        @master.call('goal/events', params, onsuccess, onerror)

    ###
    This allows programmatically trigger goal event collection without the use of front-end code.
    @param {Object} params the hash of the parameters to pass to the request
    @option params {String} list_id the list id to connect to. Get by calling lists/list()
    @option params {Struct} email a struct with one of the following keys - failing to provide anything will produce an error relating to the email address. If multiple keys are provided, the first one from the following list that we find will be used, the rest will be ignored.
         - email {String} an email address
         - euid {String} the unique id for an email address (not list related) - the email "id" returned from listMemberInfo, Webhooks, Campaigns, etc.
         - leid {String} the list email id (previously called web_id) for a list-member-info type call. this doesn't change when the email address changes
    @option params {String} campaign_id the campaign id to get content for (can be gathered using campaigns/list())
    @option params {String} event The name of the event or the URL visited
    @param {Function} onsuccess an optional callback to execute when the API call is successfully made
    @param {Function} onerror an optional callback to execute when the API call errors out - defaults to throwing the error as an exception
    ###
    recordEvent: (params={}, onsuccess, onerror) ->
        [params, onsuccess, onerror] = @master.parseArgs params, onsuccess, onerror


        @master.call('goal/record-event', params, onsuccess, onerror)


