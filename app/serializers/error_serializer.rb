class ErrorSerializer
    def self.format_error(exception, status)
      {
        message: "Your query could not be completed."
        errors: [
          {
            status: status.status_code,
            title: exception.message
          }
        ]
      }
  
    end
  end

#   {
#   "message": "your query could not be completed",
#   "errors": [
#     "string of error message one",
#     "string of error message two",
#     "etc"
#   ]
# }