# File: password_resets_controller.rb 
# Purpose of class: This class is a controller and contains action methods for 
# password resets view.
# This software follows GPL license.
# TEM-DF Group
# FGA-UnB Faculdade de Engenharias do Gama - Universidade de Brasília
class PasswordResetsController < ApplicationController

	def new
	end

	# Method for reset the password by email 
	def create
		@user = User.find_by_email_and_username(params[:email],params[:username])
		
		# Condition wich verify the user and send a email for reset his password.
		# If user exists, email will send, else, show alert.
		if @user
			@user.send_password_reset 
			redirect_to root_path, :notice => "Um e-mail foi enviado com as instruções para #{:email}."
		else
			render 'new', :alert => "Email ou nome de usuário inválidos"
		end
	end

	# Method to redirect after password change
	def edit
		@user = User.find_by_password_reset_token(params[:id])
		
		#REVIEW:this conditional should not be different?
		if !@user
			redirect_to root_url, :notice => "A senha já foi alterada."
		else
			# Nothing to do	
		end
	end

	# Method to change password
	def update
		@user = User.find_by_password_reset_token!(params[:id])

		# REVIEW: This conditional be not a default behavior. Invert
		if @user.password_reset_sent_at < 2.hours.ago
			redirect_to new_password_reset_path, :alert => "O link de redefinição de senha expirou."
		else
			new_password = params[:user][:password]
			if new_password == params[:user][:password_confirmation]
				@user.update_attribute(:password, new_password)
				@user.update_attribute(:password_reset_token, nil)
				redirect_to root_url, :notice => "Senha Redefinida!"			
			else
				redirect_to edit_password_reset_path, :alert => "Senha e Confirmação não conferem"
			end			
		end
	end
end
