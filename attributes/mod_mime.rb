# This should be an array of hashes
# Each should have 2 elements:
#   type: The Mime Type you are adding
#   extension: The file extension for the mime type
#
# Example:
# default['apache']['mod_mime']['extras'] = [
#   {
#     type: 'font/woff2',
#     extension: '.woff2'
#   }
# ]
#
default['apache']['mod_mime']['extras'] = nil
