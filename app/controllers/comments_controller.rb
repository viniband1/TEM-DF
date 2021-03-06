# File: comments_controller.rb
# Purpose of class: Contains action methods for comments view.
# This software follows GPL license.
# TEM-DF Group.
# FGA-UnB Faculdade de Engenharias do Gama - Universidade de Brasília.
class CommentsController < ApplicationController
	# Method to report a comment
	def reports
		#Receives an object of class User of current session
		@user = User.find_by_id(session[:remember_token])

		#checks if the User is admin
		if @user && @user.username == "admin"
			@reported_comments = Comment.all.where(report: true)
			CUSTOM_LOGGER.info("Showed all users")
		else
			redirect_to root_path
			CUSTOM_LOGGER.info("Failure to showed all users")
		end
	end

	# Method to deactivate a comment
	def deactivate
		#Receives an object of class User of current session
		@comment = Comment.find_by_id(params[:comment_id])
		if @comment
			@comment.update_attribute(:comment_status, false)
			CUSTOM_LOGGER.info("Comment deactivated #{@comment.to_yaml}")
		else
			CUSTOM_LOGGER.info("Failure to deactivate comment #{@comment.to_yaml}")
			missing_report
		end
		redirect_to reported_comments_path
	end

	# Method to reactivate a comment
	def reactivate
		#Receives an object of class User of current session
		@comment = Comment.find_by_id(params[:comment_id])
		if @comment
			@comment.update_attribute(:comment_status, true)
			CUSTOM_LOGGER.info("Comment reactivated #{@comment.to_yaml}")
		else
			CUSTOM_LOGGER.info("Failure to reactivate comment #{@comment.to_yaml}")
			missing_report
		end
		redirect_to reported_comments_path
	end

	# Method to remove the report in a comment
	def disable_report
		#Receives an object of class User of current session
		@comment = Comment.find_by_id(params[:comment_id])
		if @comment
			@comment.update_attribute(:report, false)
			CUSTOM_LOGGER.info("Comment report disabled #{@comment.to_yaml}")
		else
			CUSTOM_LOGGER.info("Failure to disable report #{@comment.to_yaml}")
			missing_report
		end
		redirect_to reported_comments_path
	end

	#REVIEW: it would be better to use assert?
	def missing_report
		flash.now.alert = "Erro, comentario nao encontrado."
		redirect_to reported_comments_path
	end
end
