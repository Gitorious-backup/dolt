# encoding: utf-8
#--
#   Copyright (C) 2012 Gitorious AS
#
#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU Affero General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU Affero General Public License for more details.
#
#   You should have received a copy of the GNU Affero General Public License
#   along with this program.  If not, see <http://www.gnu.org/licenses/>.
#++
require "dolt/sinatra/base"

module Dolt
  module Sinatra
    class MultiRepoBrowser < Dolt::Sinatra::Base
      def blob_url(repo, path, ref)
        "/#{repo}/blob/#{ref}:#{path}"
      end

      def tree_url(repo, path, ref)
        "/#{repo}/tree/#{ref}:#{path}"
      end

      aget "/" do
        response["Content-Type"] = "text/html"
        body("<h1>Welcome to Dolt</h1>")
      end

      aget "/*/tree/*:*" do
        tree(params[:splat][0], params[:splat][2], params[:splat][1])
      end

      aget "/*/tree/*" do
        force_ref(params[:splat], "tree", "master")
      end

      aget "/*/blob/*:*" do
        blob(params[:splat][0], params[:splat][2], params[:splat][1])
      end

      aget "/*/blob/*" do
        force_ref(params[:splat], "blob", "master")
      end

      private
      def force_ref(args, action, ref)
        redirect(args.shift + "/#{action}/#{ref}:" + args.join)
      end
    end
  end
end
