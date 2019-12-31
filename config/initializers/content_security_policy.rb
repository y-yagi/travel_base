# Be sure to restart your server when you modify this file.

# Define an application-wide content security policy
# For further information see the following documentation
# https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy

script_srcs = [:self, "www.dropbox.com", "maps.googleapis.com", "www.google-analytics.com", "cdnjs.cloudflare.com", :unsafe_inline]
script_srcs << :unsafe_eval if Rails.env.development?

Rails.application.config.content_security_policy do |policy|
  policy.default_src :self
  policy.font_src    :self, :data, "fonts.gstatic.com", "netdna.bootstrapcdn.com"
  policy.img_src     :self, :data, "www.google-analytics.com", "maps.googleapis.com", "maps.gstatic.com", "chart.googleapis.com"
  policy.object_src  :none
  policy.script_src  *script_srcs
  policy.style_src   :self, "netdna.bootstrapcdn.com", "fonts.googleapis.com", :unsafe_inline
  policy.connect_src :self, "accounts.google.com", "api.twitter.com"

  # Specify URI for violation reports
  policy.report_uri "/csp_reports"
end

# # If you are using UJS then enable automatic nonce generation
# Rails.application.config.content_security_policy_nonce_generator = -> request { SecureRandom.base64(16) }

# Report CSP violations to a specified URI
# For further information see the following documentation:
# https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy-Report-Only
Rails.application.config.content_security_policy_report_only = true
