################################################################################
# The purpose of this driver file is to generate a discussion that contains
# all types of system messages to ensure each type is working properly.  Since
# there is no public facing API for system messages, the necessary public API
# methods that cause system messages to occur must be called.
#
# This driver file assumes the Kinetic SDK is located in the relative directory:
#   - vendor/kinetic-sdk-rb
# or that this file is run from a subdirectory within the SDK samples directory:
#   - kinetic-sdk-rb/samples/discussion-system-messages
#
# The configuration file must conform to the sample-config.yaml found in the
# config subdirectory:
#   - kinetic-sdk-rb/samples/discussion-system-messages/config/sample-config.yaml
#
# 
# 1. Ensure ruby (or jruby) is installed
# 2. Create a yaml file in the 'config' directory (will be omitted from git)
# 3. ruby discussions-system-messages.rb <config-file-name.yaml>
#
################################################################################

# Determine the Present Working Directory
pwd = File.expand_path(File.dirname(__FILE__))

if Dir.exist?('vendor')
  # Require the Kinetic SDK from the vendor directory
  require File.join(pwd, 'vendor', 'kinetic-sdk-rb', 'kinetic-sdk')
elsif File.exist?(File.join(pwd, '..', '..', 'kinetic-sdk.rb'))
  # Assume this script is running from the samples directory
  require File.join(pwd, '..', '..', 'kinetic-sdk')
else
  puts "Cannot find the kinetic-sdk"
  exit
end

# Configuration file is the first command line argument
if ARGV.size == 0
  puts "A configuration file must be specified as the first parameter"
  exit
end

# Load the configuration file
config_file_name = ARGV[0]
config_file = File.join(File.expand_path(File.dirname(__FILE__)), 'config', config_file_name)
config = YAML::load_file(config_file)

# Kinetic Core SDK
core = KineticSdk::RequestCe.new(config)

# Kinetic Discussion SDK
sdk = KineticSdk::Discussions.new(config)

# Cleanup and exit if specified
if ARGV.size > 1 && ARGV[1] == "cleanup"
  JSON.parse(sdk.find_discussions.content_string)['discussions'].each do |d|
    if (d['title'].start_with?('SDK Testing'))
      puts("Deleting discussion \"#{d['title']}\" - #{d['id']}")
      sdk.delete_discussion(d['id'])
      core.find_users.content['users'].each do |user|
        if user['username'].start_with?(d['id'])
          puts ("Deleting discussion user #{user['username']}")
          core.delete_user(user)
        end
      end
    else
      puts("Keeping discussion \"#{d['title']}\" - #{d['id']}")
    end
  end
  exit
end



# Create a discussion
discussion_response = sdk.add_discussion({"title" => "SDK Testing - #{Time.now.to_i}"})
discussion = JSON.parse(discussion_response.content_string)['discussion']
discussion_id = discussion['id']


# System Message - (DiscussionUpdateMessage)
# Update the discussion
sdk.update_discussion(discussion_id, {
  "description" => "Discussion for testing system messages",
  "title" => "#{discussion['title']} - Updated"
})


# System Message - (MessageUpdatedMessage)
# Create a message and then update the message
message_response = sdk.add_message(discussion_id, "Hello World!")
message_id = JSON.parse(message_response.content_string)['message']['id']
sdk.update_message(discussion_id, message_id, "Goodbye cruel world!")


# System Message - (InvitationSentMessage)
# Invite an email
sdk.add_invitation_by_email(discussion_id, config[:invitation_email], "Join the discussion")


# System Message - (InvitationResentMessage)
# Resend the email invitation
sdk.resend_invitation_by_email(discussion_id, config[:invitation_email], "Please join the discussion")


# System Message - (InvitationRemovedMessage)
# Delete the email invitation
sdk.delete_invitation_by_email(discussion_id, config[:invitation_email])


# System Message - (ParticipantCreatedMessage)
# Create a participant
sdk.add_participant(discussion_id, config[:admin_username])


# System Message - (ParticipantRemovedMessage)
# Delete a participant
sdk.delete_participant(discussion_id, config[:admin_username])


# System Message - (ParticipantLeftMessage)
# Delete current participant
sdk.delete_participant(discussion_id, config[:username])


# System Message - (ParticipantJoinedMessage) - joinPolicy as Space Admin
sdk.subscribe(discussion_id)


# System Message - (ParticipantJoinedMessage) - joinPolicy Owning Team Member
# Join a user that is a member of an owning team.
#
# Update the discussion to be owned by a team
sdk.update_discussion(discussion_id, {"owningTeams" => [ { "name" => "Administrators" }]})
# Create an owning team member
owning_team_member = {
  "username" => "#{discussion_id}_discussion_team_member",
  "password" => discussion_id,
  "email" => "owning_team_member_email@example.com",
  "displayName" => "Discussion Owning Team Member"
}
core.add_user(
  "space_slug" => sdk.space_slug,
  "username" => owning_team_member['username'],
  "password" => owning_team_member['password'],
  "email" => owning_team_member['email'],
  "displayName" => owning_team_member['displayName'],
  "enabled" => true,
  "spaceAdmin" => false
)
core.add_team_membership("Administrators", owning_team_member['username'])
# Join the owning team member to the discussion
owning_team_member_sdk = KineticSdk::Discussions.new(config.clone.tap {|c|
  c[:username] = owning_team_member['username']
  c[:password] = owning_team_member['password']
})
owning_team_member_sdk.subscribe(discussion_id)


# System Message - (ParticipantJoinedMessage) - joinPolicy Owning User
# Join a user that is a discussion owner
#
# Create another owning user
owning_user = {
  "username" => "#{discussion_id}_discussion_owner",
  "password" => discussion_id,
  "email" => "owning_user_email@example.com",
  "displayName" => "Discussion Owning User"
}
core.add_user(
  "space_slug" => sdk.space_slug,
  "username" => owning_user['username'],
  "password" => owning_user['password'],
  "email" => owning_user['email'],
  "displayName" => owning_user['displayName'],
  "enabled" => true,
  "spaceAdmin" => false
)
# Update the discussion
sdk.update_discussion(discussion_id, {
  "owningTeams" => [{"name" => 'Default'}],
  "owningUsers" => [{"username" => owning_user['username']}]
})
owning_user_sdk = KineticSdk::Discussions.new(config.clone.tap {|c|
  c[:username] = owning_user['username']
  c[:password] = owning_user['password']
})
owning_user_sdk.subscribe(discussion_id)



# System Message - (ParticipantJoinedMessage) - Invited User
# Join a user that doesn't meet the join policy rule, but does have an invitation
#
# Create a participant user
participant_user = {
  "username" => "#{discussion_id}_discussion_participant",
  "password" => discussion_id,
  "email" => "participant@example.com",
  "displayName" => "Discussion Participant"
}
core.add_user(
  "space_slug" => sdk.space_slug,
  "username" => participant_user['username'],
  "password" => participant_user['password'],
  "email" => participant_user['email'],
  "displayName" => participant_user['displayName'],
  "enabled" => true,
  "spaceAdmin" => false
)
# Invite the user
sdk.add_invitation_by_username(discussion_id, participant_user['username'], "You are invited to join the discussion")
participant_sdk = KineticSdk::Discussions.new(config.clone.tap {|c|
  c[:username] = participant_user['username']
  c[:password] = participant_user['password']
})
participant_sdk.subscribe(discussion_id)
