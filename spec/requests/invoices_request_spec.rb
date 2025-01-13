# get all invoices for a given merchant, filtered by status

# This endpoint should:
    # render a JSON representation of all invoices for a given merchant that have a status matching the desired status query parameter

    # always return an array of data, even if one or zero resources are found

    # Only allow the status query parameter to be sent in, and only with the following values: shipped, returned or packaged
    
    # follow this pattern: GET /api/v1/merchants/:merchant_id/invoices?status=<status>