module Main where

import Control.Exception.Safe
import Control.Monad
import Control.Monad.IO.Class

-- | Fetch user data from the database
fetchUser ::
  (Monad m, MonadIO m, MonadThrow m) =>
  -- | User ID
  String ->
  m (Maybe String)
fetchUser "a1" = return $ Just "foo"
fetchUser _ = return Nothing

-- | Fetch nicknames for a given user from the database
fetchNicknames ::
  (Monad m, MonadIO m, MonadThrow m) =>
  -- | User name
  String ->
  m [String]
fetchNicknames "foo" = return ["bar"]
fetchNicknames _ = return []

-- | Parse the user ID from the heavily encrypted input string
parseUserId :: String -> Maybe String
parseUserId _ = Just "a1"

main :: IO ()
main = do
  case parseUserId "whatever" of
    Nothing -> print "can't parse"
    Just userId -> do
      mbUser <- fetchUser userId
      case mbUser of
        Nothing -> print "no user found"
        Just username -> do
          nicknames <- fetchNicknames username
          print nicknames
