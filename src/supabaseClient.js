import { createClient } from '@supabase/supabase-js'

const supabaseUrl = process.env.REACT_APP_SUPABASE_URL || 'https://ertewmqvcfzejbfvsvec.supabase.co'
const supabaseAnonKey = process.env.REACT_APP_SUPABASE_ANON_KEY || 'sb_publishable_pwjrEe6Zq1yM3jzRZjClIQ_RVVcwwDM'

export const supabase = createClient(supabaseUrl, supabaseAnonKey)
