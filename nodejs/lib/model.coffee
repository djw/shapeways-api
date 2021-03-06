### Object representing a model file on Shapeways ###
cfg = require '../cfg/config.js'
Auth = (require './auth.js').Auth
fs = require 'fs'

auth = new Auth

exports.Model = class Model  
  getModels: (oauth_access_token, oauth_access_token_secret, callback) ->
    # Note: getModels, getModel should utilize same function with overloaded optional parameter :modelId

    auth.oa.getProtectedResource "http://#{cfg.API_SERVER}/model/#{cfg.API_VERSION}", 'GET', oauth_access_token, oauth_access_token_secret, (error, data, response) ->
      if error
        console.log 'error :' + JSON.stringify error

      # Send model list
      callback data

  getModel: (id, oauth_access_token, oauth_access_token_secret, callback) ->
    # Note: getModel should utilize same function with overloaded optional parameter :modelId
    auth.oa.getProtectedResource "http://#{cfg.API_SERVER}/model/#{id}/#{cfg.API_VERSION}", 'GET', oauth_access_token, oauth_access_token_secret, (error, data, response) ->
     if error
       console.log 'error :' + JSON.stringify error

     # Send model information
     callback data
  
  putModel: (file, oauth_access_token, oauth_access_token_secret, callback) ->
    # Tests an upload - work in progress

    model_upload = fs.readFile file.path, (err, fileData) -> ##
      fileData = encodeURIComponent fileData.toString('base64')

      upload = JSON.stringify {
        file: fileData,
        fileName: file.name,
        ownOrAuthorizedModel: 1,
        acceptTermsAndConditions: 1
      }

      auth.oa.post "http://#{cfg.API_SERVER}/model/#{cfg.API_VERSION}", oauth_access_token, oauth_access_token_secret, upload, (error, data, response) ->
        if error
          console.log 'ERROR:'
          console.log error
          # Redirect to error page?
        else
          # Send model information
          callback data