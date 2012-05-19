# DON't touch ! this file is auto generated by monkey/generate_errors.rb

module Z3::Errors; end

class Z3::Errors::AccessDenied < Z3::Error
  def http_status_code
    403
  end

  def message
    %q{Access Denied}
  end
end


class Z3::Errors::AccountProblem < Z3::Error
  def http_status_code
    403
  end

  def message
    %q{There is a problem with your AWS account that prevents the operation from
completing successfully. Please use
Contact Us
.}
  end
end


class Z3::Errors::AmbiguousGrantByEmailAddress < Z3::Error
  def http_status_code
    400
  end

  def message
    %q{The e-mail address you provided is associated with more than one
account.}
  end
end


class Z3::Errors::BadDigest < Z3::Error
  def http_status_code
    400
  end

  def message
    %q{The Content-MD5 you specified did not match what we received.}
  end
end


class Z3::Errors::BucketAlreadyExists < Z3::Error
  def http_status_code
    409
  end

  def message
    %q{The requested bucket name is not available. The bucket namespace is
shared by all users of the system. Please select a different name and try
again.}
  end
end


class Z3::Errors::BucketAlreadyOwnedByYou < Z3::Error
  def http_status_code
    409
  end

  def message
    %q{Your previous request to create the named bucket succeeded and you
already own it.}
  end
end


class Z3::Errors::BucketNotEmpty < Z3::Error
  def http_status_code
    409
  end

  def message
    %q{The bucket you tried to delete is not empty.}
  end
end


class Z3::Errors::CredentialsNotSupported < Z3::Error
  def http_status_code
    400
  end

  def message
    %q{This request does not support credentials.}
  end
end


class Z3::Errors::CrossLocationLoggingProhibited < Z3::Error
  def http_status_code
    403
  end

  def message
    %q{Cross location logging not allowed. Buckets in one geographic location
cannot log information to a bucket in another location.}
  end
end


class Z3::Errors::EntityTooSmall < Z3::Error
  def http_status_code
    400
  end

  def message
    %q{Your proposed upload is smaller than the minimum allowed object
size.}
  end
end


class Z3::Errors::EntityTooLarge < Z3::Error
  def http_status_code
    400
  end

  def message
    %q{Your proposed upload exceeds the maximum allowed object size.}
  end
end


class Z3::Errors::ExpiredToken < Z3::Error
  def http_status_code
    400
  end

  def message
    %q{The provided token has expired.}
  end
end


class Z3::Errors::IllegalVersioningConfigurationException < Z3::Error
  def http_status_code
    400
  end

  def message
    %q{Indicates that the Versioning configuration specified in the request is
invalid.}
  end
end


class Z3::Errors::IncompleteBody < Z3::Error
  def http_status_code
    400
  end

  def message
    %q{You did not provide the number of bytes specified by the Content-Length
HTTP header}
  end
end


class Z3::Errors::IncorrectNumberOfFilesInPostRequest < Z3::Error
  def http_status_code
    400
  end

  def message
    %q{POST requires exactly one file upload per request.}
  end
end


class Z3::Errors::InlineDataTooLarge < Z3::Error
  def http_status_code
    400
  end

  def message
    %q{Inline data exceeds the maximum allowed size.}
  end
end


class Z3::Errors::InternalError < Z3::Error
  def http_status_code
    500
  end

  def message
    %q{We encountered an internal error. Please try again.}
  end
end


class Z3::Errors::InvalidAccessKeyId < Z3::Error
  def http_status_code
    403
  end

  def message
    %q{The AWS Access Key Id you provided does not exist in our records.}
  end
end


class Z3::Errors::InvalidAddressingHeader < Z3::Error
  def http_status_code
    0
  end

  def message
    %q{You must specify the Anonymous role.}
  end
end


class Z3::Errors::InvalidArgument < Z3::Error
  def http_status_code
    400
  end

  def message
    %q{Invalid Argument}
  end
end


class Z3::Errors::InvalidBucketName < Z3::Error
  def http_status_code
    400
  end

  def message
    %q{The specified bucket is not valid.}
  end
end


class Z3::Errors::InvalidBucketState < Z3::Error
  def http_status_code
    409
  end

  def message
    %q{The request is not valid with the current state of the bucket.}
  end
end


class Z3::Errors::InvalidDigest < Z3::Error
  def http_status_code
    400
  end

  def message
    %q{The Content-MD5 you specified was an invalid.}
  end
end


class Z3::Errors::InvalidLocationConstraint < Z3::Error
  def http_status_code
    400
  end

  def message
    %q{The specified location constraint is not valid. For more information about
Regions, see
How
to Select a Region for Your Buckets
.}
  end
end


class Z3::Errors::InvalidPart < Z3::Error
  def http_status_code
    400
  end

  def message
    %q{One or more of the specified parts could not be found. The part might
not have been uploaded, or the specified entity tag might not have matched
the part's entity tag.}
  end
end


class Z3::Errors::InvalidPartOrder < Z3::Error
  def http_status_code
    400
  end

  def message
    %q{The list of parts was not in ascending order.Parts list must specified
in order by part number.}
  end
end


class Z3::Errors::InvalidPayer < Z3::Error
  def http_status_code
    403
  end

  def message
    %q{All access to this object has been disabled.}
  end
end


class Z3::Errors::InvalidPolicyDocument < Z3::Error
  def http_status_code
    400
  end

  def message
    %q{The content of the form does not meet the conditions specified in the
policy document.}
  end
end


class Z3::Errors::InvalidRange < Z3::Error
  def http_status_code
    416
  end

  def message
    %q{The requested range cannot be satisfied.}
  end
end


class Z3::Errors::InvalidRequest < Z3::Error
  def http_status_code
    400
  end

  def message
    %q{SOAP requests must be made over an HTTPS connection.}
  end
end


class Z3::Errors::InvalidSecurity < Z3::Error
  def http_status_code
    403
  end

  def message
    %q{The provided security credentials are not valid.}
  end
end


class Z3::Errors::InvalidSOAPRequest < Z3::Error
  def http_status_code
    400
  end

  def message
    %q{The SOAP request body is invalid.}
  end
end


class Z3::Errors::InvalidStorageClass < Z3::Error
  def http_status_code
    400
  end

  def message
    %q{The storage class you specified is not valid.}
  end
end


class Z3::Errors::InvalidTargetBucketForLogging < Z3::Error
  def http_status_code
    400
  end

  def message
    %q{The target bucket for logging does not exist, is not owned by you, or
does not have the appropriate grants for the log-delivery group.}
  end
end


class Z3::Errors::InvalidToken < Z3::Error
  def http_status_code
    400
  end

  def message
    %q{The provided token is malformed or otherwise invalid.}
  end
end


class Z3::Errors::InvalidURI < Z3::Error
  def http_status_code
    400
  end

  def message
    %q{Couldn't parse the specified URI.}
  end
end


class Z3::Errors::KeyTooLong < Z3::Error
  def http_status_code
    400
  end

  def message
    %q{Your key is too long.}
  end
end


class Z3::Errors::MalformedACLError < Z3::Error
  def http_status_code
    400
  end

  def message
    %q{The XML you provided was not well-formed or did not validate against our
published schema.}
  end
end


class Z3::Errors::MalformedPOSTRequest < Z3::Error
  def http_status_code
    400
  end

  def message
    %q{The body of your POST request is not well-formed
multipart/form-data.}
  end
end


class Z3::Errors::MalformedXML < Z3::Error
  def http_status_code
    400
  end

  def message
    %q{This happens when the user sends a malformed xml (xml that doesn't
conform to the published xsd) for the configuration. The error message is,
"The XML you provided was not well-formed or did not validate against our
published schema."}
  end
end


class Z3::Errors::MaxMessageLengthExceeded < Z3::Error
  def http_status_code
    400
  end

  def message
    %q{Your request was too big.}
  end
end


class Z3::Errors::MaxPostPreDataLengthExceededError < Z3::Error
  def http_status_code
    400
  end

  def message
    %q{Your POST request fields preceding the upload file were too large.}
  end
end


class Z3::Errors::MetadataTooLarge < Z3::Error
  def http_status_code
    400
  end

  def message
    %q{Your metadata headers exceed the maximum allowed metadata size.}
  end
end


class Z3::Errors::MethodNotAllowed < Z3::Error
  def http_status_code
    405
  end

  def message
    %q{The specified method is not allowed against this resource.}
  end
end


class Z3::Errors::MissingAttachment < Z3::Error
  def http_status_code
    0
  end

  def message
    %q{A SOAP attachment was expected, but none were found.}
  end
end


class Z3::Errors::MissingContentLength < Z3::Error
  def http_status_code
    411
  end

  def message
    %q{You must provide the Content-Length HTTP header.}
  end
end


class Z3::Errors::MissingRequestBodyError < Z3::Error
  def http_status_code
    400
  end

  def message
    %q{This happens when the user sends an empty xml document as a request. The
error message is, "Request body is empty."}
  end
end


class Z3::Errors::MissingSecurityElement < Z3::Error
  def http_status_code
    400
  end

  def message
    %q{The SOAP 1.1 request is missing a security element.}
  end
end


class Z3::Errors::MissingSecurityHeader < Z3::Error
  def http_status_code
    400
  end

  def message
    %q{Your request was missing a required header.}
  end
end


class Z3::Errors::NoLoggingStatusForKey < Z3::Error
  def http_status_code
    400
  end

  def message
    %q{There is no such thing as a logging status sub-resource for a key.}
  end
end


class Z3::Errors::NoSuchBucket < Z3::Error
  def http_status_code
    404
  end

  def message
    %q{The specified bucket does not exist.}
  end
end


class Z3::Errors::NoSuchKey < Z3::Error
  def http_status_code
    404
  end

  def message
    %q{The specified key does not exist.}
  end
end


class Z3::Errors::NoSuchLifecycleConfiguration < Z3::Error
  def http_status_code
    404
  end

  def message
    %q{The lifecycle configuration does not exist.}
  end
end


class Z3::Errors::NoSuchUpload < Z3::Error
  def http_status_code
    404
  end

  def message
    %q{The specified multipart upload does not exist. The upload ID might be
invalid, or the multipart upload might have been aborted or completed.}
  end
end


class Z3::Errors::NoSuchVersion < Z3::Error
  def http_status_code
    404
  end

  def message
    %q{Indicates that the version ID specified in the request does not match an
existing version.}
  end
end


class Z3::Errors::NotImplemented < Z3::Error
  def http_status_code
    501
  end

  def message
    %q{A header you provided implies functionality that is not
implemented.}
  end
end


class Z3::Errors::NotSignedUp < Z3::Error
  def http_status_code
    403
  end

  def message
    %q{Your account is not signed up for the Amazon
S3
service. You must sign up before you can use Amazon
S3
. You can sign up at the following URL: http://aws.amazon.com/s3}
  end
end


class Z3::Errors::NotSuchBucketPolicy < Z3::Error
  def http_status_code
    404
  end

  def message
    %q{The specified bucket does not have a bucket policy.}
  end
end


class Z3::Errors::OperationAborted < Z3::Error
  def http_status_code
    409
  end

  def message
    %q{A conflicting conditional operation is currently in progress against
this resource. Please try again.}
  end
end


class Z3::Errors::PermanentRedirect < Z3::Error
  def http_status_code
    301
  end

  def message
    %q{The bucket you are attempting to access must be addressed using the
specified endpoint. Please send all future requests to this endpoint.}
  end
end


class Z3::Errors::PreconditionFailed < Z3::Error
  def http_status_code
    412
  end

  def message
    %q{At least one of the preconditions you specified did not hold.}
  end
end


class Z3::Errors::Redirect < Z3::Error
  def http_status_code
    307
  end

  def message
    %q{Temporary redirect.}
  end
end


class Z3::Errors::RequestIsNotMultiPartContent < Z3::Error
  def http_status_code
    400
  end

  def message
    %q{Bucket POST must be of the enclosure-type multipart/form-data.}
  end
end


class Z3::Errors::RequestTimeout < Z3::Error
  def http_status_code
    400
  end

  def message
    %q{Your socket connection to the server was not read from or written to
within the timeout period.}
  end
end


class Z3::Errors::RequestTimeTooSkewed < Z3::Error
  def http_status_code
    403
  end

  def message
    %q{The difference between the request time and the server's time is too
large.}
  end
end


class Z3::Errors::RequestTorrentOfBucketError < Z3::Error
  def http_status_code
    400
  end

  def message
    %q{Requesting the torrent file of a bucket is not permitted.}
  end
end


class Z3::Errors::SignatureDoesNotMatch < Z3::Error
  def http_status_code
    403
  end

  def message
    %q{The request signature we calculated does not match the signature you
provided. Check your AWS Secret Access Key and signing method. For more
information, see
REST
Authentication
and
SOAP
Authentication
for details.}
  end
end


class Z3::Errors::ServiceUnavailable < Z3::Error
  def http_status_code
    503
  end

  def message
    %q{Please reduce your request rate.}
  end
end


class Z3::Errors::SlowDown < Z3::Error
  def http_status_code
    503
  end

  def message
    %q{Please reduce your request rate.}
  end
end


class Z3::Errors::TemporaryRedirect < Z3::Error
  def http_status_code
    307
  end

  def message
    %q{You are being redirected to the bucket while DNS updates.}
  end
end


class Z3::Errors::TokenRefreshRequired < Z3::Error
  def http_status_code
    400
  end

  def message
    %q{The provided token must be refreshed.}
  end
end


class Z3::Errors::TooManyBuckets < Z3::Error
  def http_status_code
    400
  end

  def message
    %q{You have attempted to create more buckets than allowed.}
  end
end


class Z3::Errors::UnexpectedContent < Z3::Error
  def http_status_code
    400
  end

  def message
    %q{This request does not support content.}
  end
end


class Z3::Errors::UnresolvableGrantByEmailAddress < Z3::Error
  def http_status_code
    400
  end

  def message
    %q{The e-mail address you provided does not match any account on
record.}
  end
end


class Z3::Errors::UserKeyMustBeSpecified < Z3::Error
  def http_status_code
    400
  end

  def message
    %q{The bucket POST must contain the specified field name. If it is
specified, please check the order of the fields.}
  end
end

